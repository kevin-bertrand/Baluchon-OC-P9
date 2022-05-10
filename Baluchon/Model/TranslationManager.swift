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
    
    // MARK: Methods
    /// Perform the translation from french to english for a given text
    func performTranlation(of text: String) {
        _makeRequest(usingTranslationAPI: .translate, textToTranslate: text) { results in
            self.translatedText = self._getTranslation(of: results)
            NotificationManager.shared.sendFor(.updateTranslation)
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let _apiKey = "AIzaSyBoRbi74R8lfICetP5I9FpNtjV5ZRmjYhI"
    
    // MARK: Methods
    /// Perform the request to download translation
    private func _makeRequest(usingTranslationAPI api: Translation, textToTranslate: String, completion: @escaping (_ results: [String: Any]?) -> Void) {
        let urlParams = ["key": _apiKey, "q": textToTranslate, "source": "fr", "target": "en", "format": "text"]
        NetworkManager.shared.performApiRequest(for: api.getURL(), urlParams: urlParams, httpMethod: api.getHTTPMethod()) { data in
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
