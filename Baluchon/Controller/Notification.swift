//
//  Notification.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 26/04/2022.
//

import Foundation

extension Notification {
    enum BaluchonNotification: String, CaseIterable {
        case updateExchangeRate
        
        var notificationName: Notification.Name {
            return Notification.Name(rawValue: "\(self)")
        }
    }
}