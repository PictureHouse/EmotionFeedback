import SwiftUI

struct MainViewHeader: View {
    @Binding var changed: Bool
    
    @State private var presentSettingsModal = false
    @State private var edited = false
    
    var body: some View {
        HStack {
            Text("Emotion Feedback")
                .font(.system(size: 26, weight: .black, design: .rounded))
            
            Spacer()
            
            Button(action: {
                presentSettingsModal = true
            }, label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 26, height: 26)
            })
            .sheet(isPresented: $presentSettingsModal, content: {
                SettingsView(edited: $edited, changed: $changed)
                    .interactiveDismissDisabled(edited)
            })
            .sensoryFeedback(.impact, trigger: presentSettingsModal)
            .padding(4)
        }
        .bold()
        .padding()
        .foregroundStyle(Color.white)
        .background(Color.orange)
    }
}

#Preview {
    MainViewHeader(changed: .constant(false))
}
