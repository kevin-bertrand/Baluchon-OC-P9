//
//  Translation.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 26/04/2022.
//

import Foundation

class Translation {
    // MARK: Public
    var translatedText: String = ""
    
    // MARK: Methods
    /// Perform the translation from french to english for a given text
    func performTranlation(of text: String) {
        let urlParams = ["key": _apiKey, "q": text, "source": "fr", "target": "en", "format": "text"]
        makeRequest(usingTranslationAPI: .translate, urlParams: urlParams) { results in
            self.translatedText = self.getTranslation(of: results)
            self.sendNotification(for: .updateTranslation)
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let _apiKey = "AIzaSyBoRbi74R8lfICetP5I9FpNtjV5ZRmjYhI"
    
    // MARK: Methods
    /// Perform the request to download translation
    private func makeRequest(usingTranslationAPI api: TranslationAPI, urlParams: [String: String], completion: @escaping (_ results: [String: Any]?) -> Void) {
        if var components = URLComponents(string: api.getURL()) {
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in urlParams {
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
            
            if let url = components.url {
                var request = URLRequest(url: url)
                request.httpMethod = api.getHTTPMethod()
                
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: request) { result, response, error in
                    if let error = error {
                        print(error)
                        completion(nil)
                    } else {
                        if let response = response as? HTTPURLResponse, let result = result {
                            if response.statusCode == 200 || response.statusCode == 201 {
                                do {
                                    if let resultDict = try JSONSerialization.jsonObject(with: result, options: .mutableLeaves) as? [String: Any] {
                                        completion(resultDict)
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } else {
                            completion(nil)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    /// Get the translation from the response of the API
    private func getTranslation(of result: [String: Any]?) -> String {
        var translation = ""
        
        if let data = result?["data"] as? [String: Any], let translations = data["translations"] as? [[String: Any]] {
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
    
    /// Send notification when the translation is received.
    private func sendNotification(for errorName: Notification.BaluchonNotification) {
        let notificationName = errorName.notificationName
        let notification = Notification(name: notificationName, object: self, userInfo: ["name": errorName.notificationName])
        NotificationCenter.default.post(notification)
    }
}
