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
        let urlParams: [String: String] = ["base": "EUR", "apikey": _apiKey]
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
        var convertValue = ""
        
        if let rateToEuro = _rates.first(where: {$0.currency == startLanguage}),
            let endRate = _rates.first(where: { $0.currency == exchangedCurrency }) {
            let exchangedValue = (value / rateToEuro.value) * endRate.value
            convertValue = String(format: "%.3f", exchangedValue)
        }
        
        return convertValue
    }
    
    // MARK: Private
    // MARK: Properties
    private let _apiKey = "MqnRDEmKUmziyC1KPeo7nWnF8dZXtWJQ"
    private let _rateUrl = "https://api.apilayer.com/fixer/latest?"
    private let _symbolsUrl = "https://api.apilayer.com/fixer/symbols?"
    private var _rates: [Exchange] = []
    
    // MARK: Methods
    /// Gettings currency symbols
    private func _getSymbols(completionHandler: @escaping ((Data?) -> Void)) {
        let urlParams: [String: String] = ["apikey": _apiKey]
        NetworkManager.shared.performApiRequest(for: _symbolsUrl, urlParams: urlParams, httpMethod: .get) { data in
            completionHandler(data)
        }
    }
}
