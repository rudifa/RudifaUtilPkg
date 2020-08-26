//
//  StringExtTests.swift v.0.3.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 22.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import XCTest

class StringExtTests: XCTestCase {
    func test_capitalizingFirstLetter() {
        XCTAssertEqual("abc".capitalizingFirstLetter(), "Abc")
        XCTAssertEqual("".capitalizingFirstLetter(), "")
    }

    func test_capitalizeFirstLetter() {
        var str = "def"
        str.capitalizeFirstLetter()
        XCTAssertEqual(str, "Def")

        str = ""
        str.capitalizeFirstLetter()
        XCTAssertEqual(str, "")
    }

    func test_camelCaseSplit() {
        XCTAssertEqual("HelloThere".camelCaseSplit, "Hello There")
        XCTAssertEqual("".camelCaseSplit, "")
        XCTAssertEqual("A".camelCaseSplit, "A")
        XCTAssertEqual("ABRACADABRA".camelCaseSplit, "A B R A C A D A B R A")
        XCTAssertEqual("IoT".camelCaseSplit, "Io T")
        XCTAssertEqual("camelCaseSplit".camelCaseSplit, "Camel Case Split")

        let string = "camelCaseSplit"
        print("---- |\(string)| |\(string.camelCaseSplit)|")
    }
}
