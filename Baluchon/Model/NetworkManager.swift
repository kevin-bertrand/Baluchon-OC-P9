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
    func performApiRequest(for url: String, urlParams: [String: String], httpMethod: HttpMethod, completionHandler: @escaping ((Data?) -> Void)) {
        guard var components = URLComponents(string: url) else { return completionHandler(nil) }
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in urlParams {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        guard let url = components.url else {
            return completionHandler(nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 || response.statusCode == 201 {
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

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
