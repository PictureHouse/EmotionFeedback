import Foundation
import SwiftData

@Model
final class EmotionData {
    var date: Date
    var value: Double
    
    init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}
