//
//  ConstructableRequest.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import Foundation

protocol ConstructableRequest: Router {
    func buildRequest() -> URLRequest?
}

extension ConstructableRequest {
    func buildRequest() -> URLRequest? {
        var request = URLRequest(url: url)
        if method != Method.get {
            // For Upload
            if let uploadParam = uploadParameters {
                request.httpBody = uploadParam
            } else {
                // For Normal
                let dataJson = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = dataJson
            }
        }

        // MARK: Configure for other Methods (DELETE, PUT etc....)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue.uppercased()
        return request
    }
}
