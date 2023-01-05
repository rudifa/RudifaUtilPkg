//
//  IntExtTest.swift
//
//
//  Created by Rudolf Farkas on 05.01.23.
//  Copyright © 2023 Rudolf Farkas. All rights reserved.
//

import XCTest

final class IntExtTest: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_IntIncrementWrapping() throws {
        do {
            var value: Int = 1
            let count: Int = 4
            value.toNext(next: true, count: count)
            XCTAssertEqual(value, 2)
            value.toNext(next: true, count: count)
            XCTAssertEqual(value, 3)
            value.toNext(next: true, count: count)
            XCTAssertEqual(value, 0)
            value.toNext(next: true, count: count)
            XCTAssertEqual(value, 1)
        }
        do {
            var value: Int = 1
            let count: Int = 4
            value.toNext(next: false, count: count)
            XCTAssertEqual(value, 0)
            value.toNext(next: false, count: count)
            XCTAssertEqual(value, 3)
            value.toNext(next: false, count: count)
            XCTAssertEqual(value, 2)
            value.toNext(next: false, count: count)
            XCTAssertEqual(value, 1)
        }
        do {
            var value: Int = -1
            let count: Int = 4
            value.toNext(next: false, count: count)
            XCTAssertEqual(value, -1) // unchanged
        }
        do {
            let value: Int = 1
            let count: Int = 4
            let valuea = value.next(count: count)
            XCTAssertEqual(valuea, 2)
            let valueb = valuea.next(count: count)
            XCTAssertEqual(valueb, 3)
            let valuec = valueb.next(count: count)
            XCTAssertEqual(valuec, 0)
        }
        do {
            let value: Int = 1
            let count: Int = 4
            let valuea = value.prev(count: count)
            XCTAssertEqual(valuea, 0)
            let valueb = valuea.prev(count: count)
            XCTAssertEqual(valueb, 3)
            let valuec = valueb.prev(count: count)
            XCTAssertEqual(valuec, 2)
        }
    }
}
