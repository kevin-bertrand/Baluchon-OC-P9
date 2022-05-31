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
    var targetCurrency: String = "USD"
    var sourceCurrency: String = "EUR"
    
    // MARK: Methods
    /// Get current rates
    func getRates() {
        let urlParams: [String: String] = ["base": "EUR", "apikey": _apiKey]
        NetworkManager.shared(session: _ratesSession).performApiRequest(for: _rateUrl,
                                                urlParams: urlParams,
                                                httpMethod: .get) { [weak self] data in
            guard let self = self else { return }
            if let data = data,
               let exchangeData = try? JSONDecoder().decode(ExchangeData.self, from: data) {
                self._getSymbols { data in
                    if let data = data,
                        let symbolsData = try? JSONDecoder().decode(ExchangeSymbols.self, from: data) {
                        self._rates = []
                        for exchangeRate in exchangeData.rates {
                            if let symbol = symbolsData.symbols.first(where: {$0.key == exchangeRate.key}) {
                                self._rates.append(Exchange(currency: exchangeRate.key,
                                                            symbol: symbol.value,
                                                            value: exchangeRate.value))
                            }
                        }
                        self._rates = self._rates.sorted { $0.currency < $1.currency }
                        NotificationManager.shared.send(.updateExchangeRate)
                    } else {
                        NotificationManager.shared.send(.errorDuringDownloadRates)
                    }
                }
            } else {
                NotificationManager.shared.send(.errorDuringDownloadRates)
            }
        }
    }
    
    /// Convert a given value and round to the desired currency as a string
    func convertValue(_ value: Double) -> String {
        var convertValue = ""
        
        if let rateToEuro = _rates.first(where: {$0.currency == sourceCurrency}),
            let targetCurrencyRate = _rates.first(where: { $0.currency == targetCurrency }) {
            let exchangedValue = (value / rateToEuro.value) * targetCurrencyRate.value
            convertValue = String(format: "%.3f", exchangedValue)
        }
        
        return convertValue
    }
    
    // MARK: Initialization
    init(symbolsSession: URLSession = .shared, ratesSession: URLSession = .shared) {
        _symbolsSessions = symbolsSession
        _ratesSession = ratesSession
    }
    
    // MARK: Private
    // MARK: Properties
    private let _apiKey = "MqnRDEmKUmziyC1KPeo7nWnF8dZXtWJQ"
    private let _rateUrl = "https://api.apilayer.com/fixer/latest?"
    private let _symbolsUrl = "https://api.apilayer.com/fixer/symbols?"
    private var _rates: [Exchange] = []
    private let _symbolsSessions: URLSession
    private let _ratesSession: URLSession
    
    // MARK: Methods
    /// Gettings currency symbols
    private func _getSymbols(completionHandler: @escaping ((Data?) -> Void)) {
        let urlParams: [String: String] = ["apikey": _apiKey]
        NetworkManager.shared(session: _symbolsSessions).performApiRequest(for: _symbolsUrl,
                                                urlParams: urlParams,
                                                httpMethod: .get) { data in
            completionHandler(data)
        }
    }
}
