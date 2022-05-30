//
//  WeatherTests.swift
//  BaluchonTests
//
//  Created by Kevin Bertrand on 13/05/2022.
//

import XCTest
@testable import Baluchon

class WeatherTests: XCTestCase {
    var weather: WeatherManager!
    
    override func setUp() {
        super.setUp()
        weather = WeatherManager()
    }
    
    func testGivenGettingTemperature_WhenEnteringCityName_ThenWeatherArrayShouldBeNotNull() {
        // Given
        let cityName = "Paris"
        
        // When
        weather.getTemperatureOf(city: cityName)
        sleep(5)
        
        // Then
        XCTAssertTrue(weather.weathers.count == 1)
    }
    
    func testGivenArrayAlreadyHaveCity_WhenTryingToAddTheSameCity_ThenArrayMustNotChange() {
        // Given
        let cityName = "Paris"
        weather.getTemperatureOf(city: cityName)
        sleep(5)
        
        // When
        weather.getTemperatureOf(city: cityName)
        sleep(5)
        
        // Then
        XCTAssertTrue(weather.weathers.count == 1)
    }
    
    func testGivenUserEnterCoordinates_WhenTryingToGetWeather_ThenArrayShouldBeUpdate() {
        // Given
        let latitude = 48.856614
        let longitude = 2.3522219
        
        // When
        weather.getTemperatureFromCoordinates(lat: latitude, lon: longitude)
        sleep(10)
        
        // Then
        XCTAssertTrue(weather.weathers.count == 1)
        XCTAssertTrue(weather.weathers[0].name == "Paris")
    }
}
