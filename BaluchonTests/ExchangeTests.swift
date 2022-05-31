//
//  ExchangeTests.swift
//  BaluchonTests
//
//  Created by Kevin Bertrand on 13/05/2022.
//

import XCTest
@testable import Baluchon

class ExchangeTests: XCTestCase {
    var exchangeManager: ExchangeManager!
    
    func testGivenUserWhantRates_WhenDowloadingRates_ThenRatesArrayMustBeMoreThanThreeValues() {
        // Given
        _downloadCorrectRates()
        
        // When
        
        // Then
        XCTAssertTrue(exchangeManager.rates.count > 0)
    }
    
    func testGivenGetRates_WhenGettingFailedSymbolsDownload_ThenCallbackIfError() {
        // Given
        exchangeManager = _configureManager(symbolsSessionStatus: .error, ratesSessionStatus: .correctData)
        
        // When
        exchangeManager.getRates()
        
        // Then
        XCTAssertTrue(exchangeManager.rates.count == 0)
    }
    
    func testGivenGetRates_WhenGettingFailedRatesDownload_ThenCallbackIfError() {
        // Given
        exchangeManager = _configureManager(symbolsSessionStatus: .correctData, ratesSessionStatus: .error)
        
        // When
        exchangeManager.getRates()
        
        // Then
        XCTAssertTrue(exchangeManager.rates.count == 0)
    }
    
    func testGivenGetRates_WhenGettingIncorrectRatesData_ThenCallbackIfError() {
        // Given
        exchangeManager = _configureManager(symbolsSessionStatus: .correctData, ratesSessionStatus: .incorrectData)
        
        // When
        exchangeManager.getRates()
        
        // Then
        XCTAssertTrue(exchangeManager.rates.count == 0)
    }
    
    func testGivenGetRates_WhenGettingIncorrectSymbolsData_ThenCallbackIfError() {
        // Given
        exchangeManager = _configureManager(symbolsSessionStatus: .incorrectData, ratesSessionStatus: .correctData)
        
        // When
        exchangeManager.getRates()
        
        // Then
        XCTAssertTrue(exchangeManager.rates.count == 0)
    }
    
    func testGivenWantingToChangeMoney_WhenApplyRates_ThenGettingConvertedValue() {
        // Given
        _downloadCorrectRates()
        exchangeManager.sourceCurrency = "EUR"
        exchangeManager.targetCurrency = "USD"
        
        // When
        let convertedValue = exchangeManager.convertValue(5.0)
        
        // Then
        XCTAssertTrue(convertedValue == "5.392")
    }
    
    func testGivenWaintingToChangeMoney_WhenUnknownTargetCurrency_ThenTringToConvert() {
        // Given
        _downloadCorrectRates()
        exchangeManager.sourceCurrency = "EUR"
        exchangeManager.targetCurrency = "AZERTY"
        
        // When
        let convertedValue = exchangeManager.convertValue(5.0)
        
        // Then
        XCTAssertTrue(convertedValue == "")
    }
    
    private func _downloadCorrectRates() {
        exchangeManager = _configureManager(symbolsSessionStatus: .correctData, ratesSessionStatus: .correctData)
        exchangeManager.getRates()
    }
    
    private func _configureManager(symbolsSessionStatus: FakeResponseData.SessionStatus,
                                   ratesSessionStatus: FakeResponseData.SessionStatus) -> ExchangeManager {
        return ExchangeManager(symbolsSession: _configureSession(for: .exchangeSymbols, withStatus: symbolsSessionStatus),
                               ratesSession: _configureSession(for: .exchangeRates, withStatus: ratesSessionStatus))
    }
    
    private func _configureSession(for sessionData: FakeResponseData.DataFiles, withStatus status: FakeResponseData.SessionStatus) -> URLSessionFake {
        switch status {
        case .error:
            return URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        case .correctData:
            return URLSessionFake(data: FakeResponseData.getCorrectData(for: sessionData), response: nil, error: nil)
        case .incorrectData:
            return URLSessionFake(data: FakeResponseData.incorrectData, response: nil, error: nil)
        }
    }
}
