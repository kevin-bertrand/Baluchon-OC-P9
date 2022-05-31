//
//  FakeExchangeResponse.swift
//  BaluchonTests
//
//  Created by Kevin Bertrand on 30/05/2022.
//

import Foundation

class FakeExchangeResponse {
    static var exchangeCorrectData: Data {
        let bundle = Bundle(for: FakeExchangeResponse.self)
        let url = bundle.url(forResource: "symbols", withExtension: ".json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static func getCorrectData(for url: String) -> Data {
        let bundle = Bundle(for: FakeExchangeResponse.self)
        let url = bundle.url(forResource: "symbols", withExtension: ".json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let incorrectData = "Error".data(using: .utf8)!
}
