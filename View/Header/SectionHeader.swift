import SwiftUI

struct SectionHeader: View {
    let title: String
    let icon: String
    @Binding var changed: Bool
    @Binding var phone: Bool
    
    @State private var presentEmotionInputModal = false
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.orange)
                .padding()
            
            Spacer()
            
            if title == "Emotion Chart", phone == true {
                Button(action: {
                    presentEmotionInputModal = true
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                .fullScreenCover (isPresented: $presentEmotionInputModal,content: {
                    EmotionInputView(changed: $changed)
                })
                .sensoryFeedback(.impact, trigger: presentEmotionInputModal)
                .padding()
            }
        }
    }
}
