import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    let title = "Emotion Feedback"
    let body = "It's time to enter today's emotions!"
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func setAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
    }

    func pushScheduledNotification(title: String, body: String, hour: Int, minute: Int, identifier: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
                
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
