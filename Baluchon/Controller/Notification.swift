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
        case updateTranslation
        case updateWeather
        case cityAlreadyAdded = "The city you entered is already in the list!"
        case cityDoesntExist = "The city you entered doesn't exist!"
        
        var notificationName: Notification.Name {
            return Notification.Name(rawValue: "\(self)")
        }
        
        var notificationMessage: String {
            return self.rawValue
        }
    }
}
