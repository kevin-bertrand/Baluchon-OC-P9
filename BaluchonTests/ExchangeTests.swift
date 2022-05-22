//
//  ExchangeTests.swift
//  BaluchonTests
//
//  Created by Kevin Bertrand on 13/05/2022.
//

import XCTest
@testable import Baluchon

class ExchangeTests: XCTestCase {
    var exchange: ExchangeManager!
    
    override func setUp() {
        super.setUp()
        
        exchange = ExchangeManager()
        exchange.getRates()
        sleep(5)
    }
    
    func testGivenUserWhantRates_WhenDowloadingRates_ThenRatesArrayMustBeMoreThanThreeValues() {
        // Given
        
        // When
        
        // Then
        XCTAssertTrue(exchange.rates.count > 0)
    }
    
    func testGivenWantingToChangeMoney_WhenApplyRates_ThenGettingConvertedValue() {
        // Given
        exchange.sourceCurrency = "EUR"
        exchange.targetCurrency = "USD"
        
        // When
        let convertedValue = exchange.convertValue(5.0)
        
        // Then
        XCTAssertTrue(convertedValue != "5.0")
    }
    
    func testGivenWaintingToChangeMoney_WhenUnknownTargetCurrency_ThenTringToConvert() {
        // Given
        exchange.sourceCurrency = "EUR"
        exchange.targetCurrency = "AZERTY"
        
        // When
        let convertedValue = exchange.convertValue(5.0)
        
        // Then
        XCTAssertTrue(convertedValue == "")
    }
}
