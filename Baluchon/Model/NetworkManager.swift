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
    func performApiRequest(for url: String,
                           urlParams: [String: String],
                           httpMethod: HttpMethod,
                           body: [String:Any]? = nil,
                           completionHandler: @escaping ((Data?) -> Void)) {
        guard let url = _formatUrl(url, params: urlParams) else {
            return completionHandler(nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if let body = body {
            request.httpBody = _formatBody(body)
        }
        
        session.loadData(with: request) { data, error in
            if let data = data {
                completionHandler(data)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    // MARK: Initialization
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: Private
    // MARK: Properties
    private let session: NetworkSession
    
    // MARK: Methods
    /// Format the body of a request.
    private func _formatBody(_ body: [String: Any]) -> Data? {
        var bodyQuery = ""
        for (key, value) in body {
            if !bodyQuery.isEmpty {
                bodyQuery.append("&")
            }
            
            bodyQuery.append("\(key)=\(value)")
        }
        return bodyQuery.data(using: .utf8)
    }
    
    /// Format the url of a request with components
    private func _formatUrl(_ url: String, params: [String: String]) -> URL? {
        guard var components = URLComponents(string: url) else { return nil }
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        return components.url
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
