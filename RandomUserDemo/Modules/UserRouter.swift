//
//  UserRouter.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import Foundation
import Foundation
enum UserRouter: Router {
    static let UserUrl = AppUrl.apiEndpoint

    case getUsers(queryParameter: [String: String])

    var url: URL {
        switch self {
        case let .getUsers(queryParameter):
            return createUsersSearchUrl(param: queryParameter)
        }
    }
    
    var method: Method {
        switch self {
        case .getUsers:
            return .get
        }
    }

    func createUsersSearchUrl(param: [String:String]) -> URL {
        var components = URLComponents(string: Self.UserUrl)
        components?.setQueryItems(with: param)
        return components!.url!
    }
}


extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
