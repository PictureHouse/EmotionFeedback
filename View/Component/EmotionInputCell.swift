import SwiftUI

struct EmotionInputCell: View {
    let text: String
    let minEmoji: String
    let maxEmoji: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.title3)
                .foregroundStyle(Color.orange)
            
            Slider(value: $value, in: -50 ... 50, step: 1) {
            } minimumValueLabel: {
                Text(minEmoji)
                    .scaleEffect(1.5)
            } maximumValueLabel: {
                Text(maxEmoji)
                    .scaleEffect(1.5)
            }
            .sensoryFeedback(.increase, trigger: value)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

#Preview {
    EmotionInputCell(text: "test", minEmoji: "👉", maxEmoji: "👈", value: .constant(0))
}
