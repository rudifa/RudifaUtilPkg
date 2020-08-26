//
//  StringRegexExtTests.swift v.0.6.0
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 28.04.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import XCTest

class StringRegexExtTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func test_string_matches() {
        var string = "🇩🇪€4.95"
        var matched = string.matches(for: "[0-9]")
        // print(matched)
        XCTAssertEqual(matched, ["4", "9", "5"])
        print("----", string, matched, "blank= \(string.isBlank())")
        XCTAssertFalse(string.isBlank())

        string = "abra cadabra"
        matched = string.matches(for: "abra")
        // print(matched)
        XCTAssertEqual(matched, ["abra", "abra"])
        print("---", string, matched, "blank= \(string.isBlank())")
        XCTAssertFalse(string.isBlank())

        let whitespace = "^\\s*$"
        string = ""
        matched = string.matches(for: whitespace)
        XCTAssertNotEqual(matched, [])
        print("---", string, matched, "blank= \(string.isBlank())")
        XCTAssertTrue(string.isBlank())

        string = " \t  \n"
        matched = string.matches(for: whitespace)
        XCTAssertNotEqual(matched, [])
        print("---", string, matched, "blank= \(string.isBlank())")

        string = " \t  \n"
        matched = string.matches(for: whitespace)
        XCTAssertNotEqual(matched, [])
        print("---", string, matched, "blank= \(string.isBlank())")

        string = "xyz"
        matched = string.matches(for: whitespace)
        XCTAssertEqual(matched, [])
        print("---", string, matched, "blank= \(string.isBlank())")
    }

    func test_string_doesMatch() {
        var string = "🇩🇪€4€9"
        XCTAssertTrue(string.doesMatch(regex: "[0-9]"))
        XCTAssertTrue(string.doesMatch(regex: "€"))

        let whitespace = "^\\s*$"
        string = " \t  \n"
        XCTAssertTrue(string.doesMatch(regex: whitespace))

        let shareQRCodePattern = "^\\d{10}\\.\\d{5}$"
        string = "1523953362.08907"
        XCTAssertTrue(string.doesMatch(regex: shareQRCodePattern))
    }

    func test_string_extractUUID() {
        let contains_UUID = "https://stick-scan/product_images%2F08D41FB1-8B2E-4F6F-977A-BFA876AEF775.png"
        let extracted_UUID = contains_UUID.extractUUID()
        XCTAssertEqual(extracted_UUID, "08D41FB1-8B2E-4F6F-977A-BFA876AEF775")
        XCTAssertNil("".extractUUID())
    }
}
