//
//  WeatherManager.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 26/04/2022.
//

import Foundation

class WeatherManager {
    // MARK: Public
    // MARK: Properties
    var weathers: [Weather] {
        _weathers.sorted { $0.currentLocation ?? false && !($1.currentLocation ?? false) }
    }
    
    // MARK: Properties
    /// Getting the temperature of an entered city name
    func getTemperatureOf(city: String) {
        // 1 - Get coordinates
        _getCoordinatesOf(city: city) { cityData in
            if let cityData = cityData {
                // 2 - Get temperature
                self._getTemperature(of: cityData, isCurrentLocation: false)
            } else {
                self._sendNotification(for: .cityDoesntExist)
            }
        }
    }
    
    /// Getting the temperature of an entered point
    func getTemperatureFromCoordinates(lat: Double, lon: Double) {
        self._getTemperature(of: CityInformations(name: nil, lat: lat, lon: lon), isCurrentLocation: true)
    }
    
    // MARK: Private
    // MARK: Properties
    private var _weathers: [Weather] = []
    private let _apiKey = "dfd64c07c118f713c2866795defbe20f"
    private let _getLocationCityURL = "http://api.openweathermap.org/geo/1.0/direct?q="
    private let _getWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat="
    
    // MARK: Methods
    /// Getting coordinates from a given city name
    private func _getCoordinatesOf(city: String, completionHandler: @escaping ((CityInformations?) -> Void)) {
        NetworkManager.shared.performApiRequest(for: URL(string: "\(_getLocationCityURL)\(city)&appid=\(_apiKey)")) { data in
            if let data = data,
               let cityData = try? JSONDecoder().decode([CityInformations].self, from: data),
               let cityData = cityData.first {
                completionHandler(cityData)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    /// Getting temperature of a given point with its coordinates.
    private func _getTemperature(of coordinates: CityInformations, isCurrentLocation: Bool) {
        NetworkManager.shared.performApiRequest(for: URL(string: "\(_getWeatherUrl)\(coordinates.lat)&lon=\(coordinates.lon)&units=metric&appid=\(_apiKey)")) { data in
            if let data = data,
                var weatherData = try? JSONDecoder().decode(Weather.self, from: data) {
                // Check if a name was given when checking coordinates (more precise than name on weather forecasts).
                if let cityName = coordinates.name {
                    weatherData.name = cityName
                }
                // Check if the new weather forecast is the user current location
                if isCurrentLocation {
                    weatherData.currentLocation = true
                }
                // Check if the new city is already shown at the user
                guard !self._checkIfCityIsAlreadyShown(weatherData.name) else { return }
                // Download the condition icon
                self._dowloadConditionImage(for: weatherData) { weather in
                    self._weathers.append(weather)
                    self._sendNotification(for: .updateWeather)
                }
            } else {
                // If there is an error during downloading the temperature -> sending a notification error
                self._sendNotification(for: .errorDuringDownloadingWeather)
            }
        }
    }
    
    /// Checking if the entered city is already in shown
    private func _checkIfCityIsAlreadyShown(_ cityName: String?) -> Bool {
        if let cityName = cityName,
           self._weathers.contains(where: { $0.name == cityName}) {
            self._sendNotification(for: .cityAlreadyAdded)
            return true
        } else {
            return false
        }
    }
    
    /// Getting the icon of the current weather condition
    private func _dowloadConditionImage(for weather: Weather, completionHandler: @escaping((Weather) -> Void)) {
        NetworkManager.shared.performApiRequest(for: URL(string:  "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")) { data in
            if let icon = data {
                var newWeatherInformations = weather
                newWeatherInformations.icon = icon
                completionHandler(newWeatherInformations)
            } else {
                completionHandler(weather)
            }
        }
    }
    
    /// Configure and send a notification to the controller
    private func _sendNotification(for errorName: Notification.BaluchonNotification) {
        let notificationName = errorName.notificationName
        let notification = Notification(name: notificationName, object: self, userInfo: ["name": errorName.notificationName])
        NotificationCenter.default.post(notification)
    }
}
