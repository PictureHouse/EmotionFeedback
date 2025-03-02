import SwiftUI

@main
struct EmotionFeedbackApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var appStateManager = AppStateManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(appStateManager)
        }
    }
}
