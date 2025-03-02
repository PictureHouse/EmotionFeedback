import SwiftUI

struct SplashView: View {
    @Environment(AppStateManager.self) private var appStateManager
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("icon2.0_body")
                .resizable()
                .frame(width: 300, height: 300)
            
            HStack {
                Text("Emotion Feedback")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(Color(.orange))
            }
            
            Spacer()
            
            Text("[Version \(appStateManager.version)] 2024 Yune Cho")
                .foregroundStyle(Color(.orange))
                .padding(.bottom)
        }
    }
}

#Preview {
    SplashView()
        .environment(AppStateManager())
}
