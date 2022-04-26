//
//  ExchangeRates.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import Foundation

class ExchangeRates {
    // MARK: Public
    // MARK: Properties
//    var data: [Exchange] = [Exchange(currency: "Euro", symbol: "EUR", value: 1.3), Exchange(currency: "Pounds", symbol: "PND", value: 0.5)]
    
    var rates: [Exchange] { _rates }
    
    // MARK: Methods
    func getRates() {
        getRates { data in
            if let data = data, let exchangeData = try? JSONDecoder().decode(ExchangeData.self, from: data){
                print(exchangeData)
            }
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let _rateUrl = URL(string: "http://data.fixer.io/api/latest?access_key=d266eca0a81e01912c00972d3c550bc1&base=EUR")!
    private let _symbolsUrl = URL(string: "http://data.fixer.io/api/symbols?access_key=d266eca0a81e01912c00972d3c550bc1")!
    private var _rates: [Exchange] = []
    
    // MARK: Methods
    private func getRates(completionHandler: @escaping ((Data?) -> Void)) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: _rateUrl) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let exchangeData = try? JSONDecoder().decode(ExchangeData.self, from: data) {
                self.getSymbols { data in
                    if let data = data,
                        let symbolsData = try? JSONDecoder().decode(ExchangeSymbols.self, from: data) {
                        for exchangeRate in exchangeData.rates {
                            if let symbol = symbolsData.symbols.first(where: {$0.key == exchangeRate.key}) {
                                self._rates.append(Exchange(currency: exchangeRate.key, symbol: symbol.value, value: exchangeRate.value))
                            }
                        }
                        self._rates = self._rates.sorted { $0.currency < $1.currency }
                        self.sendNotification(for: .updateExchangeRate)
                    }
                }
                completionHandler(data)
            }
        }
        task.resume()
    }
    
    private func getSymbols(completionHandler: @escaping ((Data?) -> Void)) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: _symbolsUrl) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completionHandler(data)
            }
        }
        task.resume()
    }
    
    /// Configure and send a notification to the controller
    private func sendNotification(for errorName: Notification.BaluchonNotification) {
        let notificationName = errorName.notificationName
        let notification = Notification(name: notificationName, object: self, userInfo: ["name": errorName.notificationName])
        NotificationCenter.default.post(notification)
    }
    
    // MARK: Structures
    struct ExchangeData: Codable {
        let base: String
        let rates: [String: Double]
    }

    struct ExchangeSymbols: Codable {
        let symbols: [String: String]
    }
}
