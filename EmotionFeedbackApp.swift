import SwiftUI
import SwiftData

@main
struct EmotionFeedbackApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var appStateManager = AppStateManager()
    @State private var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(appStateManager)
                .environment(notificationManager)
                .modelContainer(for: EmotionData.self)
                .preferredColorScheme(.light)
        }
    }
}
