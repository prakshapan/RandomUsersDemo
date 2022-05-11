//
//  Network.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import Foundation
import Combine

class Network: NSObject {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    struct DataResponse {
        let value: Data
        let statusCode: Int
    }

    var router: Router
    lazy var webService = WebOperation()
    init(router: Router) {
        self.router = router
    }

    func request<T: Decodable>(_ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        webService.router = router
        guard let request = webService.buildRequest() else { fatalError("Cannot build Request") }
        print("""
            /** Request **/
            URL: \(String.init(describing: router.url))
            Header: \(String.init(describing: router.headers))
            Method: \(String.init(describing: router.method))
            Parameters: \(String.init(describing: router.parameters))
            -------------------------------------------
            """
        )

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .validateStatusCode()
            .tryMap { result -> Response<T> in

                if let response = result.response as? HTTPURLResponse {
                    print("""
                        /** Response **/
                        StatusCode: \(String.init(describing: response.statusCode ))
                        Response: \(NetworkUtils.serializeJSON(data: result.data))
                        -------------------------------------------
                        """
                    )
                }


                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func request() -> AnyPublisher<DataResponse, Error> {
        webService.router = router
        guard let request = webService.buildRequest() else { fatalError("Cannot build Request") }
        print("""
            /** Request **/
            URL: \(String.init(describing: router.url))
            Header: \(String.init(describing: router.headers))
            Method: \(String.init(describing: router.method))
            Parameters: \(String.init(describing: router.parameters))
            UploadParameters: \(String.init(describing: router.uploadParameters))
            -------------------------------------------
            """
        )
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .validateStatusCode()
            .tryMap { result -> DataResponse in
                let statusCode = (result.response as? HTTPURLResponse)?.statusCode ?? 499
                print("""
                        /** Response **/
                        StatusCode: \(String.init(describing: statusCode ))
                        Response: \(String.init(describing: NetworkUtils.serializeJSON(data: result.data)))
                        -------------------------------------------
                        """
                )
                return DataResponse(value: result.data, statusCode: statusCode)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var urlRequest: URLRequest {
        var request = URLRequest(url: router.url)
        request.httpMethod = router.method.rawValue
        request.httpBody = try? JSONSerialization.data(withJSONObject: router.parameters, options: [])
        request.allHTTPHeaderFields = router.headers
        return request
    }

}


struct ErrorCodable: Codable, Error {
    var statue: String
}
