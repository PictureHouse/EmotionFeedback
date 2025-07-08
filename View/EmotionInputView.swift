import SwiftUI

struct EmotionInputView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var changed: Bool
    
    @State private var today = Date.now
    @State private var calendarId: Int = 0
    @State private var answer = [Double](repeating: 0.0, count: 5)
    
    var body: some View {
        VStack {
            HStack {
                Text("👋 Hello! How are you today?")
                    .font(.system(size: 23, weight: .black, design: .rounded))
                Spacer()
            }
            .padding()
            .foregroundStyle(Color.white)
            .background(Color.orange)
            
            ScrollView {
                DatePicker("0. Select today’s date.", selection: $today, in: ...Date(), displayedComponents: .date)
                    .padding()
                    .foregroundStyle(Color.orange)
                    .font(.title3)
                    .datePickerStyle(.compact)
                    .sensoryFeedback(.selection, trigger: today)
                    .id(calendarId)
                    .onChange(of: today) {
                      calendarId += 1
                    }
                
                EmotionInputCell(
                    text: "1. How good did you feel when you woke up this morning?",
                    minEmoji: "😡",
                    maxEmoji: "😄",
                    value: $answer[0]
                )
                
                EmotionInputCell(
                    text: "2. Were there many people who made you happy today?",
                    minEmoji: "🙅‍♂️",
                    maxEmoji: "🙆‍♂️",
                    value: $answer[1]
                )
                
                EmotionInputCell(
                    text: "3. Were there any things you were grateful for today?",
                    minEmoji: "🙅‍♂️",
                    maxEmoji: "🙆‍♂️",
                    value: $answer[2]
                )

                EmotionInputCell(
                    text: "4. Did you laugh a lot today?",
                    minEmoji: "🙅‍♂️",
                    maxEmoji: "🙆‍♂️",
                    value: $answer[3]
                )
                
                EmotionInputCell(
                    text: "5. How are you feeling right now?",
                    minEmoji: "😡",
                    maxEmoji: "😄",
                    value: $answer[4]
                )
                
                HStack {
                    TextButton(title: "Save", accent: true) {
                        updateEmotion()
                        changed = true
                        dismiss()
                    }
                    .padding(.horizontal)
                    .sensoryFeedback(.success, trigger: changed)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Not now")
                    }
                    .padding(.horizontal)
                    .foregroundStyle(Color.gray)
                }
                
                Spacer()
            }
        }
        .background(Color.white)
    }
}

private extension EmotionInputView {
    func updateEmotion() {
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yyyy"
        let year_string = formatter_year.string(from: today)
        let year = Int(year_string)
        
        let formatter_month = DateFormatter()
        formatter_month.dateFormat = "MM"
        let month_string = formatter_month.string(from: today)
        let month = Int(month_string)
        
        let formatter_day = DateFormatter()
        formatter_day.dateFormat = "dd"
        let day_string = formatter_day.string(from: today)
        let day = Int(day_string)
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let calender = Calendar.current
        let date = calender.date(from: dateComponents)!
        
        var sum: Double = 0.0
        for i in 0 ..< 5 {
            sum += answer[i]
        }
        let avg = sum / 5.0
        
        UserData.shared.updateEmotionData(date: date, value: avg)
    }
}
