import SwiftUI

@main
struct EmotionFeedbackApp: App {
    @State private var appStateManager = AppStateManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(appStateManager)
        }
    }
}
