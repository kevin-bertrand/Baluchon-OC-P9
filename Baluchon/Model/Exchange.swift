//
//  Exchange.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import Foundation

struct Exchange {
    let currency: String
    let symbol: String
    let value: Double
}

struct ExchangeData: Codable {
    let base: String
    let rates: [String: Double]
}

struct ExchangeSymbols: Codable {
    let symbols: [String: String]
}
