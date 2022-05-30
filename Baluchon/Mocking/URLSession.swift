//
//  URLSession.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 27/05/2022.
//

import Foundation

extension URLSession: NetworkSession {
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: request) { data, _, error in
            completionHandler(data, error)
        }
        
        task.resume()
    }
}
