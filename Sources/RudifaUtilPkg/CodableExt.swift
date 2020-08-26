//
//  CodableExt.swift v.0.2.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 23.06.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import Foundation

/**
 Extensions originated in https://gist.github.com/StanislavK/e763cdc9fbe92f62f3c9dbd648e7e7ad

 Usage examples

     struct Language: Codable {
         var name: String
         var version: String
     }

     // create an instance
     let language = Language(name: "Swift", version: "4")

     // encode
     if let data = try? language.encode() {
         // use data here
     }

     // decode
     if let lang = try? Language.decode(from: data!) {
         // use lang here
     }
 */
extension Encodable {
    /// Encodes self into Data
    ///
    /// - Parameter encoder: defaults to JSONEncoder
    /// - Returns: encoded Data
    /// - Throws: on error
    public func encode(_ encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

extension Decodable {
    /// Decodes Data into Self
    ///
    /// - Parameters:
    ///   - decoder: defaults to JSONDecoder
    ///   - data: previously encoded Data
    /// - Returns: a Self value
    /// - Throws: on error
    public static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
