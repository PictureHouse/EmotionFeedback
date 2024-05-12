import SwiftUI

struct SplashView: View {
    let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    
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
            
            Text("[Version \(version)] 2024 Yune Cho")
                .foregroundStyle(Color(.orange))
                .padding(.bottom)
        }
    }
}

#Preview {
    SplashView()
}
