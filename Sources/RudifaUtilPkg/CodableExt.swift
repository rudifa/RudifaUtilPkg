//
//  CodableExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 23.06.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import Foundation

/**
 ###Usage examples:###

 ````
     struct Language: Codable {
         var name: String
         var version: String
     }
 ````

 Create an instance
 ````
    let language = Language(name: "Swift", version: "5.7")
 ````
 Encode to Data? and decode to a new Language instance

 ````
 if let data: Data = language.encode() {
    // use data here...

    // decode from Data
    if let lang = Language.decode(from: data) {
         // use lang here
    } else {
         // handle decode error
    }
 } else {
     // handle encode error
 }
 ````

 Encode instance to String? and decode to a new Language instance

 ````
 if let string: String = language.encode() {
    // use string here...

    // decode from String
    if let lang = Language.decode(from: string) {
        // use lang here
    } else {
        // handle decode error
    }
 } else {
    // handle encode error
 }
 ````
 */

public extension Encodable {
    /// Encode self into Data
    /// THROWING VERSION REMOVED
    /// - Parameter encoder: defaults to JSONEncoder
    /// - Returns: encoded Data
    /// - Throws: on error
    //    public func encode(_ encoder: JSONEncoder = JSONEncoder()) throws -> Data {
    //        return try encoder.encode(self)
    //    }

    /// Encode self into Data?
    /// - Parameter encoder: defaults to JSONEncoder
    /// - Returns: Data?
    func encode(_ encoder: JSONEncoder = JSONEncoder()) -> Data? {
        try? encoder.encode(self)
    }

    /// Encode self into a String?
    /// - Parameter encoder: defaults to JSONEncoder
    /// - Returns: String?
    func encode(_ encoder: JSONEncoder = JSONEncoder()) -> String? {
        if let data: Data = encode(encoder) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    /// Encode self into a json String?
    /// - Returns: String?
    var encode: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        if let data = try? encoder.encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    /// Encode self into a json String?
    /// - Returns: String?
    var json: String? {
        encode
    }

    /// Encode self into a prettyprinted json String?
    /// - Returns: String?
    var jsonpp: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        if let data = try? encoder.encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

/**
 Usage examples: see `extension Encodable`
 */
public extension Decodable {
    /// Decode Data into Self
    /// THROWING VERSION REMOVED
    /// - Parameters:
    ///   - decoder: defaults to JSONDecoder
    ///   - data: previously encoded Data
    /// - Returns: a Self value
    /// - Throws: on error
    //    public static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
    //        return try decoder.decode(Self.self, from: data)
    //    }

    /// Decode Data into Self?
    /// - Parameters:
    ///   - decoder: defaults to JSONDecoder
    ///   - data: previously encoded Data
    /// - Returns: Self?
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) -> Self? {
        try? decoder.decode(Self.self, from: data)
    }

    /// Decode String into Self?
    /// - Parameters:
    ///   - decoder: defaults to JSONDecoder
    ///   - string: previously encoded String
    /// - Returns: Self?
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from string: String) -> Self? {
        if let data = string.data(using: .utf8) {
            return try? decoder.decode(Self.self, from: data)
        }
        return nil
    }
}
