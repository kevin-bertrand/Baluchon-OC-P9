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
    var weathers: [Weather] = []
    
    // MARK: Properties
    func getTemperatureOf(city: String) {
        _getCoordinatesOf(city: city) { weatherData in
            if let weatherData = weatherData {
                if self.weathers.contains(where: { $0.name == weatherData.name}) {
                    self.sendNotification(for: .cityAlreadyAdded)
                } else {
                    self.dowloadConditionImage(for: weatherData) { weather in
                        self.weathers.append(weather)
                        self.sendNotification(for: .updateWeather)
                    }
                }
            } else {
                self.sendNotification(for: .cityDoesntExist)
            }
        }
    }
    
    func getTemperatureFromCoordinates(lat: Double, lon: Double) {
        _getTemperature(of: Coordinates(lat: lat, lon: lon)) { weather in
            if var weather = weather {
                weather.currentLocation = true
                if self.weathers.contains(where: { $0.name == weather.name}) {
                    self.sendNotification(for: .cityAlreadyAdded)
                } else {
                    self.dowloadConditionImage(for: weather) { weather in
                        self.weathers.append(weather)
                        self.sendNotification(for: .updateWeather)
                    }
                }
            } else {
                self.sendNotification(for: .cannotGetCurrentLocation)
            }
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let _apiKey = "dfd64c07c118f713c2866795defbe20f"
    private let _getLocationCityURL = "http://api.openweathermap.org/geo/1.0/direct?q="
    private let _getWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat="
    
    // MARK: Methods
    private func _getCoordinatesOf(city: String, completionHandler: @escaping ((Weather?) -> Void)) {
        let session = URLSession(configuration: .default)
        let url = "\(_getLocationCityURL)\(city)&appid=\(_apiKey)"
        guard let url = URL(string: url) else {
            return completionHandler(nil)
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               let data = data,
               let cityData = try? JSONDecoder().decode([CityInformations].self, from: data),
                let cityData = cityData.first {
                self._getTemperature(of: Coordinates(lat: cityData.lat, lon: cityData.lon)) { weather in
                    var cityInformation: Weather?
                    
                    if let weather = weather {
                        cityInformation = weather
                        cityInformation?.name = cityData.name
                    }

                    completionHandler(cityInformation)
                }
            } else {
                return completionHandler(nil)
            }
        }
        task.resume()
    }
    
    private func _getTemperature(of coordinates: Coordinates, completionHandler: @escaping ((Weather?) -> Void)) {
        let session = URLSession(configuration: .default)
        let url = "\(_getWeatherUrl)\(coordinates.lat)&lon=\(coordinates.lon)&units=metric&appid=\(_apiKey)"

        guard let url = URL(string: url) else {
            return completionHandler(nil)
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               let data = data,
               let weatherData = try? JSONDecoder().decode(Weather.self, from: data) {
                completionHandler(weatherData)
            } else {
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
    /// Configure and send a notification to the controller
    private func sendNotification(for errorName: Notification.BaluchonNotification) {
        let notificationName = errorName.notificationName
        let notification = Notification(name: notificationName, object: self, userInfo: ["name": errorName.notificationName])
        NotificationCenter.default.post(notification)
    }
    
    private func dowloadConditionImage(for weather: Weather, completionHandler: @escaping((Weather) -> Void)) {
        if let imageUrl = URL(string:  "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: imageUrl) { data, response, error in
                if let icon = data {
                    var newWeatherInformations = weather
                    newWeatherInformations.icon = icon
                    completionHandler(newWeatherInformations)
                } else {
                    completionHandler(weather)
                }
            }
            task.resume()
        } else {
            completionHandler(weather)
        }
    }
}
