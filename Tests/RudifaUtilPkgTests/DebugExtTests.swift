//
//  DebugExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 23.07.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import XCTest

class DebugExtTests: XCTestCase {
    @available(*, deprecated) // silence warnings
    func test_printClassAndFunc() {
        printClassAndFunc(info: "more info")
        printClassAndFunc(info: "@ even more info at this time")
        printClassAndFunc(info: "@ even more info a tad later")

        printClassAndFunc()
        printClassAndFunc("")
        printClassAndFunc("more info")
        printClassAndFunc("@ even more info at this time")
        printClassAndFunc("@ even more info a tad later")

        XCTAssertEqual(formatClassAndFunc(info: "more info"),
                       "---- DebugExtTests.test_printClassAndFunc() more info")

        XCTAssertMatchesRegex(formatClassAndFunc(info: "@"),
                              #"^---- \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{6} DebugExtTests.test_printClassAndFunc\(\) $"#)

        XCTAssertMatchesRegex(formatClassAndFunc(info: "@ even more info at this time"),
                              #"^---- \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{6} DebugExtTests.test_printClassAndFunc\(\)  even more info at this time$"#)
    }
}
