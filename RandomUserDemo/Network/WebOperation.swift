//
//  WebOperation.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import Foundation

struct WebOperation: ConstructableRequest {

    var router: Router!

    var url: URL {
        return router.url
    }

    var method: Method {
        return router.method
    }

    var parameters: [String: Any] {
        return router.parameters
    }

    var headers: [String: String] {
        return router.headers
    }

    var uploadParameters: Data? {
        return router.uploadParameters
    }
}
