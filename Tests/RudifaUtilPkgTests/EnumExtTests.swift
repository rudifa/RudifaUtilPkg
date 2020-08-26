//
//  EnumExtTests.swift v.0.3.0
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 18.03.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import XCTest

class EnumExtTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    enum Windrose: CaseIterable, Equatable {
        case north, east, south, west
    }

    func test_enum_next() {
        var side = Windrose.north
        XCTAssertEqual(side, .north)
        side = side.next
        XCTAssertEqual(side, .east)
        side = side.next
        XCTAssertEqual(side, .south)
        side = side.next
        XCTAssertEqual(side, .west)
        side = side.next
        XCTAssertEqual(side, .north)
        side = side.next
        XCTAssertEqual(side, .east)
    }

    func test_enum_prev() {
        var side = Windrose.north
        XCTAssertEqual(side, .north)
        side = side.prev
        XCTAssertEqual(side, .west)
        side = side.prev
        XCTAssertEqual(side, .south)
        side = side.prev
        XCTAssertEqual(side, .east)
        side = side.prev
        XCTAssertEqual(side, .north)
        side = side.prev
        XCTAssertEqual(side, .west)
    }

    func test_enum_increment() {
        var side = Windrose.north
        XCTAssertEqual(side, .north)
        side.increment(next: true)
        XCTAssertEqual(side, .east)
        side.increment(next: true)
        XCTAssertEqual(side, .south)
        side.increment(next: true)
        XCTAssertEqual(side, .west)
        side.increment(next: true)
        XCTAssertEqual(side, .north)
        side.increment(next: true)
        XCTAssertEqual(side, .east)

        side.increment(next: false)
        XCTAssertEqual(side, .north)
        side.increment(next: false)
        XCTAssertEqual(side, .west)
        side.increment(next: false)
        XCTAssertEqual(side, .south)
        side.increment(next: false)
        XCTAssertEqual(side, .east)
        side.increment(next: false)
        XCTAssertEqual(side, .north)
        side.increment(next: false)
        XCTAssertEqual(side, .west)

    }

    func test_enum_incremented() {
        var side = Windrose.north
        XCTAssertEqual(side, .north)

        XCTAssertEqual(side.incremented(next: true), .east)
        XCTAssertEqual(side.incremented(next: true), .south)
        XCTAssertEqual(side.incremented(next: true), .west)
        XCTAssertEqual(side.incremented(next: true), .north)
        XCTAssertEqual(side.incremented(next: true), .east)

        XCTAssertEqual(side.incremented(next: false), .north)
        XCTAssertEqual(side.incremented(next: false), .west)
        XCTAssertEqual(side.incremented(next: false), .south)
        XCTAssertEqual(side.incremented(next: false), .east)
        XCTAssertEqual(side.incremented(next: false), .north)
    }
}

