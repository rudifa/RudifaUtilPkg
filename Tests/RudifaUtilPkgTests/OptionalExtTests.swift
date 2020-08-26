//
//  OptionalExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 15.10.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import XCTest

class OptionalExtTests: XCTestCase {
    func testOptionalIntIncrement() {
        var ival: Int?
        ival.increment()
        XCTAssertEqual(ival, 1)

        struct Stats {
            var count: Int?
        }

        var stats = Stats()
        stats.count.increment()
        XCTAssertEqual(stats.count, 1)
        stats.count.increment(by: -1)
        XCTAssertEqual(stats.count, 0)
    }
}
