//
//  DataExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 07.10.22.
//

import XCTest

final class DataExtTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_toInt() throws {
        var testInt = 12_345_678
        let testData = Data(bytes: &testInt, count: MemoryLayout<Int>.size)

        let testInt2 = testData.toInt
        XCTAssertEqual(testInt2, testInt)
    }

    func test_binInt32() throws {
        var testInt: Int32 = 12_345_678
        let testData = Data(bytes: &testInt, count: MemoryLayout<Int32>.size)

        let testInt2: Int32 = testData.binInt()
        XCTAssertEqual(testInt2, testInt)
    }

    func test_binUInt8() throws {
        var testInt: UInt8 = 255
        let testData = Data(bytes: &testInt, count: MemoryLayout<UInt8>.size)

        let testInt2: UInt8 = testData.binInt()
        XCTAssertEqual(testInt2, testInt)
    }
}
