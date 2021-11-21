//
//  DoubleExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 20.11.21.
//  Copyright © 2021 Rudolf Farkas. All rights reserved.
//

import XCTest

class DoubleExtTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_DoubleExt() throws {
        XCTAssertEqual(123.456.fmt02, "123.46")
        XCTAssertEqual((123.456 / 35000.0).fmt08, "0.00352731")
    }
}
