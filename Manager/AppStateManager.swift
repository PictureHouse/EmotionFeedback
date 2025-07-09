import SwiftUI
import Observation

@Observable
final class AppStateManager {
    let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
}
