//
//  TranslationManager.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 26/04/2022.
//

import Foundation

class TranslationManager {
    // MARK: Public
    var translatedText: String = ""
    var sourceLanguage: String = "fr"
    var targetLanguage: String = "en"
    var supportedTargetLanguages: [Language] {
        _supportedTargetLanguages
    }
    var supportedSourceLanguages: [Language] {
        _supportedSourceLanguages
    }
    
    // MARK: Methods
    /// Perform the translation from french to english for a given text
    func performTranlation(of text: String) {
        if sourceLanguage == "auto" {
            _detectLanguage(of: text)
        } else {
            _makeTranslateRequest(of: text)
        }
    }
    
    /// Download supported languaages 
    func getSupportedLanguages() {
        let urlParams = ["key": _apiKey]
        NetworkManager.shared.performApiRequest(for: Translation.supportedLanguages.getURL(), urlParams: urlParams, httpMethod: .post, body: ["target": "en"]) { data in
            if let data = data,
               let supportedLanguages = try? JSONDecoder().decode(SupportedLanguagesData.self, from: data){
                self._supportedTargetLanguages = supportedLanguages.data.languages
                self._supportedSourceLanguages = self._supportedTargetLanguages
                self._supportedSourceLanguages.insert(Language(language: "auto", name: "Auto-detection"), at: 0)
                NotificationManager.shared.sendFor(.supportedLanguagesDowloaded)
            }
        }
    }
            
    // MARK: Private
    // MARK: Properties
    private let _apiKey = "AIzaSyBoRbi74R8lfICetP5I9FpNtjV5ZRmjYhI"
    private var _supportedTargetLanguages: [Language] = [Language(language: "en", name: "English"), Language(language: "fr", name: "French")]
    private var _supportedSourceLanguages: [Language] = [Language(language: "en", name: "English"), Language(language: "fr", name: "French")]
    
    // MARK: Methods
    /// Perform the request to download translation
    private func _makeTranslateRequest(of textToTranslate: String) {
        let urlParams = ["key": _apiKey, "q": textToTranslate, "source": sourceLanguage, "target": targetLanguage, "format": "text"]
        NetworkManager.shared.performApiRequest(for: Translation.translate.getURL(), urlParams: urlParams, httpMethod: Translation.translate.getHTTPMethod(), body: nil) { data in
            if let data = data {
                do {
                    if let resultDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {
                        self.translatedText = self._getTranslation(of: resultDict)
                        NotificationManager.shared.sendFor(.updateTranslation)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                NotificationManager.shared.sendFor(.errorDuringTranslating)
            }
        }
    }
    
    /// Get the translation from the response of the API
    private func _getTranslation(of result: [String: Any]?) -> String {
        var translation = ""
        
        if let data = result?["data"] as? [String: Any],
           let translations = data["translations"] as? [[String: Any]] {
            var allTranslation = [String]()
            for translation in translations {
                if let translatedText = translation["translatedText"] as? String {
                    allTranslation.append(translatedText)
                }
            }
            
            if allTranslation.count > 0 {
                translation = allTranslation[0]
            }
        }
        
        return translation
    }
    
    /// Detect source language
    private func _detectLanguage(of text: String) {
        let urlParams = ["q": text, "key": _apiKey]
        NetworkManager.shared.performApiRequest(for: Translation.detectLanguage.getURL(), urlParams: urlParams, httpMethod: Translation.detectLanguage.getHTTPMethod()) { data in
            if let data = data,
               let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any],
               let language = self._getDetectedSourceLanguage(of: jsonData){
                self.sourceLanguage = language
                NotificationManager.shared.sendFor(.updateSourceLanguage)
                self._makeTranslateRequest(of: text)
            } else {
                NotificationManager.shared.sendFor(.cannotDetectLanguage)
            }
        }
    }
    
    /// Get the detected source language
    private func _getDetectedSourceLanguage(of result: [String: Any]) -> String? {
        var sourceLanguage: String?
        
        if let data = result["data"] as? [String: Any]{
            if let languages = data["detections"] as? [[[String: Any]]] {
                if let detectedLanguage = languages.first?.first?["language"] as? String {
                    sourceLanguage = detectedLanguage
                }
            }
        }
           
        
        return sourceLanguage
    }
}
