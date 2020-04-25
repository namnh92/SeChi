//
//  HMReminderService.swift
//  HeyBeri
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMReminderService: NSObject {
    
    // MARK: - Singleton
    static let instance = HMReminderService()
    
    func createReminder(_ reminder: TaskReminder) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Reminder", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: reminder.taskName, arguments: nil)
        content.sound = UNNotificationSound.default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1);
        content.categoryIdentifier = "reminderLocal"
        // Deliver the notification in 60 seconds.
        var timeInterval: TimeInterval = 60.0
        if let date = Date.getDateBy(string: "2020-04-25 18:39", format: Date.dateHourFormat) {
            timeInterval = date.timeIntervalSince(Date())
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest.init(identifier: "reminderLocal", content: content, trigger: trigger)
        
        let acceptAction = UNNotificationAction(identifier: "accept", title: "Đồng ý", options: [])
        let deleteAction = UNNotificationAction(identifier: "delete", title: "Từ chối", options: [.destructive])
        let helpAction = UNNotificationAction(identifier: "help", title: "Nhờ trợ giúp", options: [])
        let category = UNNotificationCategory(identifier: "reminderLocal", actions: [acceptAction, deleteAction, helpAction], intentIdentifiers: [], options: [])
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
        center.add(request)
    }
}
