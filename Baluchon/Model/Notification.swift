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
        
        // Translation notification
        case updateTranslation
        case errorDuringTranslating = "An error occurs during the translation. Please try again!"
        
        // Weather notifications
        case updateWeather
        case cityAlreadyAdded = "The city you entered is already in the list!"
        case cityDoesntExist = "The city you entered doesn't exist!"
        case cannotGetCurrentLocation = "Your current location cannot be found!"
        case errorDuringDownloadingWeather = "An error occurs when getting temperature! Please, try later!"
        
        var notificationName: Notification.Name {
            return Notification.Name(rawValue: "\(self)")
        }
        
        var notificationMessage: String {
            return self.rawValue
        }
    }
}
