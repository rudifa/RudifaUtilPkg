//
//  TimeIntervalExtTests.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 31.08.21.
//  Copyright © 2021 Rudolf Farkas. All rights reserved.
//

import XCTest

class TimeIntervalExtTests: XCTestCase {
    func test_TimeIntervalFromDays() {
        XCTAssertEqual(TimeInterval(days: 1), 86_400.0)
        XCTAssertEqual(TimeInterval(days: 100), 8_640_000.0)
    }
}
