//
//  CodableExtTests.swift v.0.2.0
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 23.06.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import XCTest

class CodableExtTests: XCTestCase {
    /// A codable struct for use in tests
    struct Language: Codable, Equatable {
        var name: String
        var version: String
    }

    override func setUp() {}

    override func tearDown() {}

    func testEncodableDecodable() {
        let language = Language(name: "Swift", version: "5")

        // encode into data and decode
        let data = try? language.encode()
        let language2 = try? Language.decode(from: data!)
        XCTAssertEqual(language, language2)

        // decode invalid data
        let language3 = try? Language.decode(from: Data())
        XCTAssertNil(language3)
    }
}
