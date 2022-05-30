//
//  NetworkSession.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 27/05/2022.
//

import Foundation

protocol NetworkSession {
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void)
}
