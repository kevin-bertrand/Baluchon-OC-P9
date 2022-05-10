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
    func sendFor(_ errorName: Notification.BaluchonNotification) {
        let notificationName = errorName.notificationName
        let notification = Notification(name: notificationName, object: self, userInfo: ["name": errorName.notificationName])
        NotificationCenter.default.post(notification)
    }
}
