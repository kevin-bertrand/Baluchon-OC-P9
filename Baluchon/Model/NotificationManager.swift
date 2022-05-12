//
//  NotificationManager.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 10/05/2022.
//

import Foundation

class NotificationManager {
    // MARK: Public
    // MARK: Properties
    static let shared = NotificationManager()
    
    // MARK: Methods
    /// Send notification according to a given error 
    func sendFor(_ name: Notification.BaluchonNotification) {
        let notificationName = name.notificationName
        let notification = Notification(name: notificationName, object: self, userInfo: ["name": name.notificationName])
        NotificationCenter.default.post(notification)
    }
}
