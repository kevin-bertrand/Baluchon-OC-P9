//
//  NetworkManager.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 10/05/2022.
//

import Foundation

class NetworkManager {
    // MARK: Public
    // MARK: Properties
    static let shared = NetworkManager()
    
    // MARK: Methods
    func performApiRequest(for url: URL?, completionHandler: @escaping ((Data?) -> Void)) {
        let session = URLSession(configuration: .default)
        
        guard let url = url else {
            return completionHandler(nil)
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                completionHandler(data)
            } else {
                completionHandler(nil)
            }
        }
        task.resume()
    }
    // MARK: Private
    // MARK: Properties
    
    // MARK: Methods
}
