//
//  TranslationAPI.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 26/04/2022.
//

import Foundation

enum Translation {
    case detectLanguage
    case translate
    case supportedLanguages
    
    func getURL() -> String {
        var urlString = ""
        
        switch self {
        case .detectLanguage:
            urlString = "https://translation.googleapis.com/language/translate/v2/detect"
        case .translate:
            urlString = "https://translation.googleapis.com/language/translate/v2"
        case .supportedLanguages:
            urlString = "https://translation.googleapis.com/language/translate/v2/languages"
        }
        
        return urlString
    }
    
    func getHTTPMethod() -> HttpMethod {
        if self == .supportedLanguages {
            return .get
        } else {
            return .post
        }
    }
}
