//
//  DateExtUTCTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 03.02.23.
//  Copyright © 2023 Rudolf Farkas. All rights reserved.
//

import XCTest

final class DateExtUTCTests: XCTestCase {
    private let utcTimeZone = TimeZone(abbreviation: "UTC")!

    override func setUpWithError() throws {
        // All test will use UTC time zone.
        TimeZone.ReferenceType.default = utcTimeZone
    }

    override func tearDownWithError() throws {
        // Reset to current
        TimeZone.ReferenceType.default = TimeZone.current
    }

    func test_MillisecondTimestamps() {
        do {
            let date = Date(timeIntervalSince1970: 1_675_373_197.591)
            printClassAndFunc("date: \(date.ddMMyyyy_HHmmss_𝜇s) \(date.millisecondsSince1970)")
            XCTAssertEqual(date.millisecondsSince1970, 1_675_373_197_591)
            XCTAssertEqual(date.wholeMonth!.millisecondsSince1970, 1_675_209_600_000)
            XCTAssertEqual(date.wholeMonth!.incremented(by: .month).millisecondsSince1970, 1_677_628_800_000)
        }
    }
}
