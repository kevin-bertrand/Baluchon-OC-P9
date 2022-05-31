//
//  TranslationTests.swift
//  BaluchonTests
//
//  Created by Kevin Bertrand on 13/05/2022.
//

import XCTest
@testable import Baluchon

class TranslationTests: XCTestCase {
    var translationManager: TranslationManager!
    
    func testGivenTryingToGetSupportedLanguages_WhenGettingFailed_ThenCallbackError() {
        // Given
        translationManager = _configureManager(detectLanguageSessionStatus: .correctData,
                                               translateSessionStatus: .correctData,
                                               getSupportedLanguagesSessionStatus: .error)
        translationManager.getSupportedLanguages()
        
        // When
        
        
        // Then
        XCTAssertTrue(translationManager.supportedTargetLanguages.count == 2)
        XCTAssertTrue(translationManager.supportedSourceLanguages.count == 2)
    }
    
    func testGivenTryingToGetSupportedLanguages_WhenGettingIncorrectData_ThenCallbackError() {
        // Given
        translationManager = _configureManager(detectLanguageSessionStatus: .correctData,
                                               translateSessionStatus: .correctData,
                                               getSupportedLanguagesSessionStatus: .incorrectData)
        translationManager.getSupportedLanguages()
        
        // When
        
        
        // Then
        XCTAssertTrue(translationManager.supportedTargetLanguages.count == 2)
        XCTAssertTrue(translationManager.supportedSourceLanguages.count == 2)
    }
    
    func testGivenTryingToGetSupportedLanguages_WhenDowloadingSupportedLanguages_ThenArrayMustBeFilled() {
        // Given
        _getSupportedLanguages()
        
        // When
        
        
        // Then
        XCTAssertTrue(translationManager.supportedTargetLanguages.count > 0)
        XCTAssertTrue(translationManager.supportedSourceLanguages.count > 0)
        XCTAssertTrue(translationManager.supportedSourceLanguages.count == (translationManager.supportedTargetLanguages.count+1))
    }
    
    func testGivenTextToTranslate_WhenGettingFailed_ThenCallbackError() {
        // Given
        translationManager = _configureManager(detectLanguageSessionStatus: .correctData,
                                               translateSessionStatus: .error,
                                               getSupportedLanguagesSessionStatus: .correctData)
        translationManager.getSupportedLanguages()
        translationManager.targetLanguage = "en"
        translationManager.sourceLanguage = "fr"
        let textToTranslate = "bonjour"
        
        // When
        translationManager.performTranlation(of: textToTranslate)
        
        // Then
        XCTAssertTrue(translationManager.translatedText == "")
    }
    
    func testGivenTextToTranslate_WhenGettingIncorrectData_ThenCallbackError() {
        // Given
        translationManager = _configureManager(detectLanguageSessionStatus: .correctData,
                                               translateSessionStatus: .incorrectData,
                                               getSupportedLanguagesSessionStatus: .correctData)
        translationManager.getSupportedLanguages()
        translationManager.targetLanguage = "en"
        translationManager.sourceLanguage = "fr"
        let textToTranslate = "bonjour"
        
        // When
        translationManager.performTranlation(of: textToTranslate)
        
        // Then
        XCTAssertTrue(translationManager.translatedText == "")
    }
    
    func testGivenTextToTranslate_WhenTranslateFromFrenchToEnglish_ThenGetTranslationInEnglish() {
        // Given
        _getSupportedLanguages()
        translationManager.targetLanguage = "en"
        translationManager.sourceLanguage = "fr"
        let textToTranslate = "bonjour"
        
        // When
        translationManager.performTranlation(of: textToTranslate)
        
        // Then
        XCTAssertTrue(translationManager.translatedText == "hello")
    }
    
    func testGivenAutoDetectionText_WhenGettingFailed_ThenCallbackError() {
        // Given
        translationManager = _configureManager(detectLanguageSessionStatus: .error,
                                               translateSessionStatus: .correctData,
                                               getSupportedLanguagesSessionStatus: .correctData)
        translationManager.getSupportedLanguages()
        translationManager.sourceLanguage = "auto"
        translationManager.targetLanguage = "en"
        let textToTranslate = "bonjour"
        
        // When
        translationManager.performTranlation(of: textToTranslate)
        
        // Then
        XCTAssertTrue(translationManager.translatedText == "")
    }
    
    func testGivenAutoDetectionText_WhenGettingIncorrectData_ThenCallbackError() {
        // Given
        translationManager = _configureManager(detectLanguageSessionStatus: .incorrectData,
                                               translateSessionStatus: .correctData,
                                               getSupportedLanguagesSessionStatus: .correctData)
        translationManager.getSupportedLanguages()
        translationManager.sourceLanguage = "auto"
        translationManager.targetLanguage = "en"
        let textToTranslate = "bonjour"
        
        // When
        translationManager.performTranlation(of: textToTranslate)
        
        // Then
        XCTAssertTrue(translationManager.translatedText == "")
    }
    
    func testGivenAutoDetectionText_WhenTranslationInEnglish_ThenGetTextInEnglish() {
        // Given
        _getSupportedLanguages()
        translationManager.sourceLanguage = "auto"
        translationManager.targetLanguage = "en"
        let textToTranslate = "bonjour"
        
        // When
        translationManager.performTranlation(of: textToTranslate)
        
        // Then
        XCTAssertTrue(translationManager.sourceLanguage == "fr")
        XCTAssertTrue(translationManager.translatedText == "hello")
    }
    
    private func _getSupportedLanguages() {
        translationManager = _configureManager(detectLanguageSessionStatus: .correctData,
                                               translateSessionStatus: .correctData,
                                               getSupportedLanguagesSessionStatus: .correctData)

        translationManager.getSupportedLanguages()
    }
    
    private func _configureManager(detectLanguageSessionStatus: FakeResponseData.SessionStatus,
                                   translateSessionStatus: FakeResponseData.SessionStatus,
                                   getSupportedLanguagesSessionStatus: FakeResponseData.SessionStatus) -> TranslationManager {
        return TranslationManager(detectLanguageSession: _configureSession(for: .detectLanguage, withStatus: detectLanguageSessionStatus),
                           translateSession: _configureSession(for: .getTranslation, withStatus: translateSessionStatus),
                           getSupportedLanguagesSession: _configureSession(for: .getSupportedLanguages, withStatus: getSupportedLanguagesSessionStatus))
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
