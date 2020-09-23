//
//  CodableExtTests.swift v.0.2.0
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 23.06.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import XCTest

struct Language: Codable, Equatable {
    var name: String
    var version: String
}

class CodableExtTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func test_EncodableDecodable_Data() {
        let language = Language(name: "Swift", version: "5.3")

        // encode to Data?
        guard let data: Data = language.encode() else {
            XCTFail("language.encode()")
            return
        }

        // decode to Self?
        guard let language2 = Language.decode(from: data) else {
            XCTFail("Language.decode()")
            return
        }

        // compare
        XCTAssertEqual(language, language2)

        // test with empty Data
        let language3 = Language.decode(from: Data())
        XCTAssertNil(language3)
    }

    func test_EncodableDecodable_String() {
        let language = Language(name: "Swift", version: "5.3")

        // encode to String?
        guard let string: String = language.encode() else {
            XCTFail("language.encode()")
            return
        }
        XCTAssertEqual(string, #"{"name":"Swift","version":"5.3"}"#)

        // decode to Self?
        guard let language2 = Language.decode(from: string) else {
            XCTFail("Language.decode()")
            return
        }

        // compare
        XCTAssertEqual(language, language2)

        // test with empty String
        let language3 = Language.decode(from: String())
        XCTAssertNil(language3)
    }

    func test_Both() {
        // create an instance
        let language = Language(name: "Swift", version: "5.3")

        // encode to Data?
        if let data: Data = language.encode() {
            // use data here

            // decode from Data
            if let lang = Language.decode(from: data) {
                // use lang here
                XCTAssertEqual(lang, language)
            } else {
                // handle decode error
                XCTFail("let lang = Language.decode(from: data)")
            }
        } else {
            // handle encode error
            XCTFail("let data: Data = language.encode()")
        }

        // encode to String?
        if let string: String = language.encode() {
            // use string here
            XCTAssertEqual(string, #"{"name":"Swift","version":"5.3"}"#)

            // decode from String
            if let lang = Language.decode(from: string) {
                // use lang here
                XCTAssertEqual(lang, language)
            } else {
                // handle decode error
                XCTFail("let lang = Language.decode(from: string)")
           }
        } else {
            // handle encode error
            XCTFail("let string: String = language.encode()")
        }
    }
}
