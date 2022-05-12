//
//  ExchangeManager.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import Foundation

class ExchangeManager {
    // MARK: Public
    // MARK: Properties
    var rates: [Exchange] { _rates }
    var exchangedCurrency: String = "USD"
    var startLanguage: String = "EUR"
    
    // MARK: Methods
    /// Get current rates
    func getRates() {
        let urlParams: [String: String] = ["access_key": _apiKey]
        NetworkManager.shared.performApiRequest(for: _rateUrl, urlParams: urlParams, httpMethod: .get) { data in
            if let data = data,
               let exchangeData = try? JSONDecoder().decode(ExchangeData.self, from: data) {
                self._getSymbols { data in
                    if let data = data,
                        let symbolsData = try? JSONDecoder().decode(ExchangeSymbols.self, from: data) {
                        self._rates = []
                        for exchangeRate in exchangeData.rates {
                            if let symbol = symbolsData.symbols.first(where: {$0.key == exchangeRate.key}) {
                                self._rates.append(Exchange(currency: exchangeRate.key, symbol: symbol.value, value: exchangeRate.value))
                            }
                        }
                        self._rates = self._rates.sorted { $0.currency < $1.currency }
                        NotificationManager.shared.sendFor(.updateExchangeRate)
                    } else {
                        NotificationManager.shared.sendFor(.errorDuringDownloadRates)
                    }
                }
            } else {
                NotificationManager.shared.sendFor(.errorDuringDownloadRates)
            }
        }
    }
    
    /// Convert a given value and round to the desired currency as a string
    func convertValue(_ value: Double) -> String {
        if let rateToEuro = _rates.first(where: {$0.currency == startLanguage}),
            let endRate = _rates.first(where: { $0.currency == exchangedCurrency }) {
            let exchangedValue = (value / rateToEuro.value) * endRate.value
            return String(format: "%.3f", exchangedValue)
        } else {
            return ""
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let _apiKey = "WN4uESIbGoy1Dj0Y32GE8ol1EEXtSeBT"
    private let _rateUrl = "http://data.fixer.io/api/latest?"
    private let _symbolsUrl = "http://data.fixer.io/api/symbols?"
    private var _rates: [Exchange] = []
    
    // MARK: Methods
    /// Gettings currency symbols
    private func _getSymbols(completionHandler: @escaping ((Data?) -> Void)) {
        let urlParams: [String: String] = ["access_key": _apiKey]
        NetworkManager.shared.performApiRequest(for: _symbolsUrl, urlParams: urlParams, httpMethod: .get) { data in
            completionHandler(data)
        }
    }
}
