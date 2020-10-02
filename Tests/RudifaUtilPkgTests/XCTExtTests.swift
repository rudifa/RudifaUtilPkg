//
//  XCTExtTests.swift v.0.1.0
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 21.03.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import Foundation
import XCTest

/// Asserts that `actual` matches the regex `pattern`
/// - Parameters:
///   - actual: string to test
///   - pattern: regex pattern to match against
///   - file: file where the mismatch occurred
///   - line: line where the mismatch occurred
func XCTAssertMatchesRegex(_ actual: String, _ pattern: String, file: StaticString = #file, line: UInt = #line) {
    if !actual.doesMatch(regex: pattern) {
        XCTFail("match '\(actual)' against pattern '\(pattern)'", file: file, line: line)
    }
}

class XCTestExtTests: XCTestCase {
    override func setUp() {}
    override func tearDown() {}

    func test_XCTAssertMatchesRegex() {
        let dateString = Date().EEEE_ddMMyyyy_HHmmss
        // XCTAssertEqual(dateString, "Friday 28.08.2020 15:27:21")
        XCTAssertMatchesRegex(dateString, #"^[A-Z][a-z]+ \d{2}\.\d{2}\.\d{4} \d{2}:\d{2}:\d{2}$"#)
    }
}
