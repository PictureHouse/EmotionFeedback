import SwiftUI

struct GuideView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @State private var scaling = false
    
    var body: some View {
        VStack {
            SheetHeader(title: "Emotion Feedback Guide") {
                dismiss()
            }
            
            ScrollView {
                GuideTitleLeftCell(
                    title: "Emotion Feedback\nMain Screen",
                    description: "You can see all of the app's items on the main screen.\nBelow are the main screen items.\n\n-Guide Screen\n-Settings\n-Chart Area\n-Input Emotion\n-Feedback Message",
                    colorScheme: colorScheme,
                    imageName: "main"
                )
                
                GuideTitleRightCell(
                    title: "Emotion Input Screen",
                    description: "Step 0.\nSelect the date to enter.\nYou can also add past data.\n\nStep 1 ~ 5.\nEnter your answer to the question by adjusting the slider value.",
                    colorScheme: colorScheme,
                    imageName: "input"
                )
                
                GuideTitleLeftCell(
                    title: "Emotion Chart Area",
                    description: "Among the emotional data you entered, you can view a chart corresponding to the last 7 days.",
                    colorScheme: colorScheme,
                    imageName: "chart"
                )
                
                GuideTitleRightCell(
                    title: "Feedback Message Area",
                    description: "If you follow the instructions below the speech bubble with the '...' mark and touch the speech bubble, the '...' mark in the speech bubble will change to a check mark and a feedback message about your chart will appear on the screen.",
                    colorScheme: colorScheme,
                    imageName: "feedback"
                )
                
                GuideTitleLeftCell(
                    title: "Settings",
                    description: "You can change 'User Name' and 'Push Message Time'.\n(Default push message time is 10PM.)",
                    colorScheme: colorScheme,
                    imageName: "settings"
                )
                
                TextButton(title: "Got It!", accent: true) {
                    dismiss()
                }
                .padding()
                .scaleEffect(scaling ? 1 : 0.9)
                .onAppear {
                    withAnimation(.spring().repeatForever()) {
                        scaling.toggle()
                    }
                }
                
                Spacer()
            }
        }
        .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
    }
}

#Preview {
    GuideView()
}
