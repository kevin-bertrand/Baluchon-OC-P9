//
//  Weather.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import Foundation
import UIKit

struct Weather: Codable {
    var currentLocation: Bool?
    var name: String
    let sys: SunInformations
    let coord: Coordinates
    let weather: [Conditions]
    let main: Temperatures
    var icon: Data?
    let timezone: Int
}

struct SunInformations: Codable {
    let country: String
    let sunrise: Date
    let sunset: Date
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

struct Conditions: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Temperatures: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct CityInformations: Codable {
    let name: String
    let lat: Double
    let lon: Double
}
