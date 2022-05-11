//
//  NetworkUtils.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import Foundation

struct NetworkUtils {
    // MARK: Serialize JSON
    @discardableResult static func serializeJSON(data: Data) -> AnyObject {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as AnyObject
        } catch let error as NSError {

            print("JSONSerialization error:\(error.localizedDescription)")
            return [:] as AnyObject
        }
    }

    static func decodeJSON<JsonCodable>(type: JsonCodable.Type, from data: Data) -> JsonCodable? where JsonCodable: Decodable {
        do {
            let decoder = JSONDecoder()
            let parsedData = try decoder.decode(type, from: data)
            return parsedData
        }
        //decodeJSON
        catch let err {
            print("Codable Error: ", err)
            return nil
        }

    }

    // PRINT DICTIONARY like JSON
    static func formatDictionaryAsJson(with dict: [String: Any]) {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: dict,
            options: [.prettyPrinted]) else {
            print("Cannot format dictionary to data.")
            return
        }
        NetworkUtils.serializeJSON(data: theJSONData)
    }
}
