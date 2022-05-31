//
//  WeatherTests.swift
//  BaluchonTests
//
//  Created by Kevin Bertrand on 13/05/2022.
//

import XCTest
@testable import Baluchon

class WeatherTests: XCTestCase {
    var weatherManager: WeatherManager!
    
    func testGivenGettingTemperatureOfUnkownCity_WhenGettingFailed_ThenCallbackError() {
        // Given
        weatherManager = _configureManager(conditionSessionStatus: .correctData, conditionImageSessionStatus: .correctData, coordinatesSessionStatus: .error)
        let cityName = "jnofinzlefn"
        
        // When
        weatherManager.getTemperatureOf(city: cityName)
        
        // Then
        XCTAssertTrue(weatherManager.weathers.count == 0)
    }
    
    func testGivenGettingTemperature_WhenGettingIncorrectData_ThenCallbackError() {
        // Given
        weatherManager = _configureManager(conditionSessionStatus: .correctData, conditionImageSessionStatus: .correctData, coordinatesSessionStatus: .incorrectData)
        let cityName = "New York"
        
        // When
        weatherManager.getTemperatureOf(city: cityName)
        
        // Then
        XCTAssertTrue(weatherManager.weathers.count == 0)
    }
    
    func testGivenGettingTemperature_WhenEnteringCityName_ThenWeatherArrayShouldBeNotNull() {
        // Given
        _downloadCorrectData()
        let cityName = "New York"
        
        // When
        weatherManager.getTemperatureOf(city: cityName)
        
        // Then
        XCTAssertTrue(weatherManager.weathers.count == 1)
    }
    
    func testGivenArrayAlreadyHaveCity_WhenTryingToAddTheSameCity_ThenArrayMustNotChange() {
        // Given
        _downloadCorrectData()
        let cityName = "New York"
        weatherManager.getTemperatureOf(city: cityName)
        
        // When
        weatherManager.getTemperatureOf(city: cityName)
        
        // Then
        XCTAssertTrue(weatherManager.weathers.count == 1)
    }
    
    func testGivenGettingCondition_WhenGettingFailed_ThenCallbackError() {
        // Given
        weatherManager = _configureManager(conditionSessionStatus: .error, conditionImageSessionStatus: .correctData, coordinatesSessionStatus: .correctData)
        let cityName = "New York"
        
        // When
        weatherManager.getTemperatureOf(city: cityName)
        
        // Then
        XCTAssertTrue(weatherManager.weathers.count == 0)
    }
    
    func testGivenGettingCondition_WhenGettingIncorrectData_ThenCallbackError() {
        // Given
        weatherManager = _configureManager(conditionSessionStatus: .incorrectData, conditionImageSessionStatus: .correctData, coordinatesSessionStatus: .correctData)
        let cityName = "New York"
        
        // When
        weatherManager.getTemperatureOf(city: cityName)
        
        // Then
        XCTAssertTrue(weatherManager.weathers.count == 0)
    }
    
    func testGivenGettingCondition_WhenGettingFailedImageCondition_ThenImageShouldBeNil() {
        // Given
        weatherManager = _configureManager(conditionSessionStatus: .correctData, conditionImageSessionStatus: .error, coordinatesSessionStatus: .correctData)
        let cityName = "New York"
        
        // When
        weatherManager.getTemperatureOf(city: cityName)
        
        // Then
        XCTAssertTrue(weatherManager.weathers.count == 1)
        XCTAssertNil(weatherManager.weathers[0].icon)
    }
    
    func testGivenGettingCondition_WhenGettingIncorrectImageCondition_ThenImageShouldBeNil() {
        // Given
        weatherManager = _configureManager(conditionSessionStatus: .correctData, conditionImageSessionStatus: .incorrectData, coordinatesSessionStatus: .correctData)
        let cityName = "New York"
        
        // When
        weatherManager.getTemperatureOf(city: cityName)
        
        // Then
        XCTAssertTrue(weatherManager.weathers.count == 1)
        XCTAssertNil(weatherManager.weathers[0].icon)
    }
    
    func testGivenUserEnterCoordinates_WhenTryingToGetWeather_ThenArrayShouldBeUpdate() {
        // Given
        _downloadCorrectData()
        let latitude = 40.7127281
        let longitude = -74.0060152
        
        // When
        weatherManager.getTemperatureFromCoordinates(lat: latitude, lon: longitude)
        
        // Then
        XCTAssertTrue(weatherManager.weathers.count == 1)
        XCTAssertTrue(weatherManager.weathers[0].name == "New York")
    }
    
    private func _downloadCorrectData() {
        weatherManager = _configureManager(conditionSessionStatus: .correctData,
                                           conditionImageSessionStatus: .correctData,
                                           coordinatesSessionStatus: .correctData)
    }
    
    private func _configureManager(conditionSessionStatus: FakeResponseData.SessionStatus,
                                   conditionImageSessionStatus: FakeResponseData.SessionStatus,
                                   coordinatesSessionStatus: FakeResponseData.SessionStatus) -> WeatherManager {
        return WeatherManager(conditionSession: _configureSession(for: .getCurrentWeatherCondition, withStatus: conditionSessionStatus),
                       conditionImageSession: _configureSession(for: .getConditionImage, withStatus: conditionImageSessionStatus),
                       coordinatesSession: _configureSession(for: .getLocation, withStatus: coordinatesSessionStatus))
    }
    
    private func _configureSession(for sessionData: FakeResponseData.DataFiles, withStatus status: FakeResponseData.SessionStatus) -> URLSessionFake {
        switch status {
        case .error:
            return URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        case .correctData:
            if sessionData == .getConditionImage {
                return URLSessionFake(data: FakeResponseData.getCorrectImage(for: sessionData), response: nil, error: nil)
            } else {
                return URLSessionFake(data: FakeResponseData.getCorrectData(for: sessionData), response: nil, error: nil)
            }
        case .incorrectData:
            return URLSessionFake(data: FakeResponseData.incorrectData, response: nil, error: nil)
        }
    }
}

extension Sequence {
    func isSorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Bool {
        var iterator = makeIterator()

        guard var previous = iterator.next() else {
            // Sequence is empty
            return true
        }

        while let current = iterator.next() {
            guard try areInIncreasingOrder(previous, current) else {
                return false
            }

            previous = current
        }

        return true
    }
}

extension Sequence where Element : Comparable {
    func isSorted() -> Bool {
        return isSorted(by: <)
    }
}
