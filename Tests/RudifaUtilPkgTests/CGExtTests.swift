//
//  CGExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 31.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

@testable import RudifaUtilPkg
import XCTest

class CGExtTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func testCGFmt() {
        XCTAssertEqual(CGFloat(1.23456789).fmt, "1.23")
        XCTAssertEqual(CGFloat(0.00314159).fmt, "0.00314")

        XCTAssertEqual(CGPoint(x: 1.23456789, y: 9.87654321).fmt, "(1.23, 9.88)")
        XCTAssertEqual(CGSize(width: 99.23456789, height: 59.87654321).fmt, "(99.23, 59.88)")

        XCTAssertEqual(CGRect(origin: CGPoint(x: 1.23456789, y: 9.87654321), size: CGSize(width: 99.23456789, height: 59.87654321)).fmt, "(1.23, 9.88),(99.23, 59.88)")
    }

    func testCGSizeArithmetic() {
        let size = CGSize(width: 360.3456, height: 480.98765)

        XCTAssertEqual(size.fmt, "(360.35, 480.99)")

        XCTAssertEqual((size * 7.543).fmt, "(2718.09, 3628.09)")
        XCTAssertEqual((size * CGFloat(7.543)).fmt, "(2718.09, 3628.09)")

        XCTAssertEqual((size / 7.543).fmt, "(47.77, 63.77)")
        XCTAssertEqual((size / CGFloat(7.543)).fmt, "(47.77, 63.77)")
    }

    func testCGPointArithmetic() {
        let point = CGPoint(x: 360.3456, y: 480.98765)

        XCTAssertEqual(point.fmt, "(360.35, 480.99)")

        XCTAssertEqual((point * 7.543).fmt, "(2718.09, 3628.09)")
        XCTAssertEqual((point * CGFloat(7.543)).fmt, "(2718.09, 3628.09)")

        XCTAssertEqual((point / 7.543).fmt, "(47.77, 63.77)")
        XCTAssertEqual((point / CGFloat(7.543)).fmt, "(47.77, 63.77)")
    }
}
