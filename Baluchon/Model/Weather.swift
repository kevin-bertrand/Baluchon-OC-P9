//
//  Weather.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import Foundation

struct Weather: Codable {
    var name: String
    let sys: SunInformations
    let coord: Coordinates
    let weather: [Conditions]
    let main: Temperatures
}

struct SunInformations: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

struct Conditions: Codable {
    let main: String
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
