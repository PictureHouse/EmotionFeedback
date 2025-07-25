import Foundation
import SwiftData

@Observable
@MainActor
final class EmotionDataManager {
    private var modelContext: ModelContext
    private let maxDaysToKeep = 7
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // Will be deprecated soon.
    func checkMigrationStatus() -> Bool {
        let swiftDataCount = fetchEmotionData().count
        
        if swiftDataCount > 0 {
            return true
        } else {
            let appStorageData = UserData.shared.getEmotionData()
            let validAppStorageCount = appStorageData.filter { $0.2 }.count
            if validAppStorageCount > 0 {
                return false
            } else {
                return true
            }
        }
    }
    
    // Will be deprecated soon.
    func migrateFromUserData() {
        let appStorageData = UserData.shared.getEmotionData()
        var migratedCount = 0
        
        print("Starting migration from UserData...")
        
        for (index, data) in appStorageData.enumerated() {
            let (date, value, isValid) = data
            
            if isValid {
                addEmotionData(date: date, value: value)
                migratedCount += 1
                print("Migrated data[\(index)]: \(formatDate(date: date)), value: \(value)")
            } else {
                print("Skipped invalid data[\(index)]")
            }
        }
        
        print("Migration completed: \(migratedCount) data migrated.")
    }
    
    func addEmotionData(date: Date, value: Double) {
        if let existingData = fetchEmotionData(for: date) {
            existingData.value = value
            print("Updated existing emotion data for \(formatDate(date: date)): \(value)")
        } else {
            let emotionData = EmotionData(date: date, value: value)
            modelContext.insert(emotionData)
            print("Added new emotion data for \(formatDate(date: date)): \(value)")
        }
        
        saveContext()
        cleanupOldData()
    }
    
    func fetchEmotionData() -> [EmotionData] {
        do {
            let descriptor = FetchDescriptor<EmotionData>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch emotion data: \(error)")
            return []
        }
    }
    
    func fetchEmotionData(for date: Date) -> EmotionData? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<EmotionData> { emotionData in
            emotionData.date >= startOfDay && emotionData.date < endOfDay
        }
        
        do {
            let descriptor = FetchDescriptor<EmotionData>(predicate: predicate)
            let results = try modelContext.fetch(descriptor)
            return results.first
        } catch {
            print("Failed to fetch emotion data for date: \(error)")
            return nil
        }
    }
    
    func analyzeEmotionData() -> [Int] {
        let sortedData = fetchEmotionData().sorted { $0.date < $1.date }
        
        var count = 0
        var positiveCount = 0
        var negativeCount = 0
        var zeroCount = 0
        var upCount = 0
        var downCount = 0
        var bigChangeCount = 0
        
        for (index, emotionData) in sortedData.enumerated() {
            count += 1
            let value = emotionData.value
            
            if value > 0 {
                positiveCount += 1
            } else if value < 0 {
                negativeCount += 1
            } else {
                zeroCount += 1
            }
            
            if index > 0 {
                let previousValue = sortedData[index - 1].value
                
                if value > 0 && previousValue < 0 {
                    upCount += 1
                } else if value < 0 && previousValue > 0 {
                    downCount += 1
                }
                
                if abs(value - previousValue) > 50.0 {
                    bigChangeCount += 1
                }
            }
        }
        
        return [count, positiveCount, negativeCount, zeroCount, upCount, downCount, bigChangeCount]
    }
    
    func deleteEmotionData(_ emotionData: EmotionData) {
        modelContext.delete(emotionData)
        saveContext()
    }
    
    func deleteAllEmotionData() {
        do {
            let descriptor = FetchDescriptor<EmotionData>()
            let allData = try modelContext.fetch(descriptor)
            
            for data in allData {
                modelContext.delete(data)
            }
            saveContext()
        } catch {
            print("Failed to delete all emotion data: \(error)")
        }
    }
    
    private func cleanupOldData() {
        do {
            let calendar = Calendar.current
            let cutoffDate = calendar.date(byAdding: .day, value: -maxDaysToKeep, to: Date()) ?? Date()
            
            let predicate = #Predicate<EmotionData> { emotionData in
                emotionData.date < cutoffDate
            }
            
            let descriptor = FetchDescriptor<EmotionData>(predicate: predicate)
            let oldData = try modelContext.fetch(descriptor)
            
            for data in oldData {
                modelContext.delete(data)
            }
            
            if !oldData.isEmpty {
                print("Deleted \(oldData.count) old emotion data entries")
                saveContext()
            }
        } catch {
            print("Failed to cleanup old data: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
