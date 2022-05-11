//
//  ErrorExtension.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import Foundation
import Combine

typealias DataTaskResult = (data: Data, response: URLResponse)

extension Publisher where Output == DataTaskResult {
    func validateStatusCode() -> AnyPublisher<Output, NetworkError> {
        return self
            .mapError { .error($0) }
            .flatMap { (result) -> AnyPublisher<DataTaskResult, NetworkError> in
                let (data, _) = result
                if let response = result.response as? HTTPURLResponse {
                    dump("Status Code: \(response.statusCode)")
                    switch response.statusCode {
                    case 200...300:
                        return Just(result)
                            .setFailureType(to: NetworkError.self)
                            .eraseToAnyPublisher()
                    case 400...500:
                        return Fail(outputType: Output.self, failure: .clientError(result.data))
                            .eraseToAnyPublisher()
                    default:
                        return Fail(outputType: Output.self, failure: .jsonError(data))
                            .eraseToAnyPublisher()
                    }
                } else {
                    return Fail(outputType: Output.self, failure: .jsonError(data))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }

}

enum NetworkError: Error {
    case error(Error)
    case jsonError(Data)
    case clientError(Data)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .jsonError(let data): return data.description
        case .error(let error): return error.localizedDescription
        case .clientError(let data):
            let decode = NetworkUtils.decodeJSON(type: ClientError.self, from: data)
            return decode?.error ?? "Something went wrong."
        }
    }
}

struct ClientError: Codable, Error {
    var error: String
}
