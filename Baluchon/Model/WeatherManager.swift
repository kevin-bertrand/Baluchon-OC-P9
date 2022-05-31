//
//  WeatherManager.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 26/04/2022.
//

import Foundation
import UIKit

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
        _getCoordinatesOf(city) { [weak self] cityData in
            guard let self = self else { return }
            if let cityData = cityData {
                // 2 - Get temperature
                self._getTemperature(of: cityData, isCurrentLocation: false)
            } else {
                NotificationManager.shared.send(.cityDoesntExist)
            }
        }
    }
    
    /// Getting the temperature of an entered point
    func getTemperatureFromCoordinates(lat: Double, lon: Double) {
        self._getTemperature(of: CityInformations(name: nil, lat: lat, lon: lon), isCurrentLocation: true)
    }
    
    // MARK: Initialization
    init(conditionSession: URLSession = .shared, conditionImageSession: URLSession = .shared, coordinatesSession: URLSession = .shared) {
        _getCoordinatesSession = coordinatesSession
        _getImageSession = conditionImageSession
        _getConditionSession = conditionSession
    }
    
    // MARK: Private
    // MARK: Properties
    private var _weathers: [Weather] = []
    private let _apiKey = "dfd64c07c118f713c2866795defbe20f"
    private let _getLocationCityURL = "http://api.openweathermap.org/geo/1.0/direct?"
    private let _getWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?"
    private let _getImageSession: URLSession
    private let _getConditionSession: URLSession
    private let _getCoordinatesSession: URLSession
    
    // MARK: Methods
    /// Getting coordinates from a given city name
    private func _getCoordinatesOf(_ city: String, completionHandler: @escaping ((CityInformations?) -> Void)) {
        let urlParams = ["q": city, "appid":_apiKey]
        NetworkManager.shared(session: _getCoordinatesSession).performApiRequest(for: _getLocationCityURL,
                                                urlParams: urlParams,
                                                httpMethod: .get) { data in
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
        let urlParams = ["lat": "\(coordinates.lat)",
                         "lon": "\(coordinates.lon)",
                         "units":"metric",
                         "appid": _apiKey]
        NetworkManager.shared(session: _getConditionSession).performApiRequest(for: _getWeatherUrl,
                                                urlParams: urlParams,
                                                httpMethod: .get) { [weak self] data in
            guard let self = self else { return }
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
                    NotificationManager.shared.send(.updateWeather)
                }
            } else {
                // If there is an error during downloading the temperature -> sending a notification error
                NotificationManager.shared.send(.errorDuringDownloadingWeather)
            }
        }
    }
    
    /// Checking if the entered city is already in shown
    private func _checkIfCityIsAlreadyShown(_ cityName: String?) -> Bool {
        var cityAlreadyShown: Bool = false
        if let cityName = cityName,
           self._weathers.contains(where: { $0.name == cityName}) {
            NotificationManager.shared.send(.cityAlreadyAdded)
            cityAlreadyShown = true
        }
        return cityAlreadyShown
    }
    
    /// Getting the icon of the current weather condition
    private func _dowloadConditionImage(for weather: Weather, completionHandler: @escaping((Weather) -> Void)) {
        NetworkManager.shared(session: _getImageSession).performApiRequest(for: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png",
                                                urlParams: [:],
                                                httpMethod: .get) { data in
            if let data = data, let _ = UIImage(data: data) {
                var newWeatherInformations = weather
                newWeatherInformations.icon = data
                completionHandler(newWeatherInformations)
            } else {
                completionHandler(weather)
            }
        }
    }
}
