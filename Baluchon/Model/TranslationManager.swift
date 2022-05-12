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
    var supportedLanguages: [Language] = [Language(language: "en", name: "English"), Language(language: "fr", name: "French")]
    
    // MARK: Methods
    /// Perform the translation from french to english for a given text
    func performTranlation(of text: String) {
        _makeTranslateRequest(usingTranslationAPI: .translate, textToTranslate: text) { results in
            self.translatedText = self._getTranslation(of: results)
            NotificationManager.shared.sendFor(.updateTranslation)
        }
    }
    
    /// Download supported languaages 
    func getSupportedLanguages() {
        let urlParams = ["key": _apiKey]
        NetworkManager.shared.performApiRequest(for: Translation.supportedLanguages.getURL(), urlParams: urlParams, httpMethod: .post, body: ["target": "en"]) { data in
            if let data = data,
               let supportedLanguages = try? JSONDecoder().decode(SupportedLanguagesData.self, from: data){
                self.supportedLanguages = supportedLanguages.data.languages
            }
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let _apiKey = "AIzaSyBoRbi74R8lfICetP5I9FpNtjV5ZRmjYhI"
    
    // MARK: Methods
    /// Perform the request to download translation
    private func _makeTranslateRequest(usingTranslationAPI api: Translation, textToTranslate: String, completion: @escaping (_ results: [String: Any]?) -> Void) {
        let urlParams = ["key": _apiKey, "q": textToTranslate, "source": sourceLanguage, "target": targetLanguage, "format": "text"]
        NetworkManager.shared.performApiRequest(for: api.getURL(), urlParams: urlParams, httpMethod: api.getHTTPMethod(), body: nil) { data in
            if let data = data {
                do {
                    if let resultDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {
                        completion(resultDict)
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
}
