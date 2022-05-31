//
//  FakeResponseData.swift
//  BaluchonTests
//
//  Created by Kevin Bertrand on 30/05/2022.
//

import Foundation

class FakeResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class ResponseError: Error {} // Protocol not an instance
    static let error = ResponseError()
    
    static func getCorrectData(for url: DataFiles) -> Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: url.rawValue, withExtension: ".json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static func getCorrectImage(for url: DataFiles) -> Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: url.rawValue, withExtension: ".png")
        let data = try! Data(contentsOf: url!)
        print(data)
        return data
    }
    
    static let incorrectData = "Error".data(using: .utf8)!
    
    enum DataFiles: String {
        case exchangeSymbols = "symbols"
        case exchangeRates = "rates"
        case detectLanguage = "detectionLanguage"
        case getTranslation = "translation"
        case getSupportedLanguages = "supportedLanguages"
        case getCurrentWeatherCondition = "weatherConditions"
        case getLocation = "getLocation"
        case getConditionImage = "conditionImage"
        case getSecondWeatherConditions = "secondWeatherConditions"
    }
    
    enum SessionStatus {
        case error
        case correctData
        case incorrectData
    }
}
