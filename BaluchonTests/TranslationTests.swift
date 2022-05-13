//
//  TranslationTests.swift
//  BaluchonTests
//
//  Created by Kevin Bertrand on 13/05/2022.
//

import XCTest
@testable import Baluchon

class TranslationTests: XCTestCase {
    var translation: TranslationManager!
    
    override func setUp() {
        super.setUp()
        translation = TranslationManager()
        
        translation.getSupportedLanguages()
        sleep(5)
    }
    
    func testGivenTryingToGetSupportedLanguages_WhenDowloadingSupportedLanguages_ThenArrayMustBeFilled() {
        // Given
        
        
        // When
        
        
        // Then
        XCTAssertTrue(translation.supportedTargetLanguages.count > 0)
        XCTAssertTrue(translation.supportedSourceLanguages.count > 0)
        XCTAssertTrue(translation.supportedSourceLanguages.count == (translation.supportedTargetLanguages.count+1))
    }
    
    func testGivenTextToTranslate_WhenTranslateFromFrenchToEnglish_ThenGetTranslationInEnglish() {
        // Given
        translation.targetLanguage = "en"
        translation.sourceLanguage = "fr"
        let textToTranslate = "Bonjour"
        
        // When
        translation.performTranlation(of: textToTranslate)
        sleep(5)
        
        // Then
        XCTAssertTrue(translation.translatedText == "Hello")
    }
    
    func testGivenAutoDetectionText_WhenTranslationInEnglish_ThenGetTextInEnglish() {
        // Given
        translation.sourceLanguage = "auto"
        translation.targetLanguage = "en"
        let textToTranslate = "Bonjour"
        
        // When
        translation.performTranlation(of: textToTranslate)
        sleep(5)
        
        // Then
        XCTAssertTrue(translation.sourceLanguage == "fr")
        XCTAssertTrue(translation.translatedText == "Hello")
    }
}
