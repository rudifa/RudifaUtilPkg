//
//  EnumExtTests.swift
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

    @available(*, deprecated) // silence warnings
    func test_func_next() {
        // func next() modifies the value forwards (or backwards) circularly
        enum MyEnum: CaseIterable { case a, b, c }
        var letter = MyEnum.a; XCTAssertEqual(letter, .a)
        letter.next(); XCTAssertEqual(letter, .b)
        letter.next(); XCTAssertEqual(letter, .c)
        letter.next(); XCTAssertEqual(letter, .a)
        letter.next(); XCTAssertEqual(letter, .b)
        letter.next(false); XCTAssertEqual(letter, .a)
        letter.next(false); XCTAssertEqual(letter, .c)
        letter.next(false); XCTAssertEqual(letter, .b)
        letter.next(false); XCTAssertEqual(letter, .a)
    }

    @available(*, deprecated) // silence warnings
    func test_func_next_2() {
        // func next() modifies the value forwards (or backwards) circularly
        var side = Windrose.north; XCTAssertEqual(side, .north)
        side.next(); XCTAssertEqual(side, .east)
        side.next(true); XCTAssertEqual(side, .south)
        side.next(); XCTAssertEqual(side, .west)
        side.next(); XCTAssertEqual(side, .north)
        side.next(); XCTAssertEqual(side, .east)

        side.next(false); XCTAssertEqual(side, .north)
        side.next(false); XCTAssertEqual(side, .west)
        side.next(false); XCTAssertEqual(side, .south)
        side.next(false); XCTAssertEqual(side, .east)
        side.next(false); XCTAssertEqual(side, .north)
    }

    func test_func_toNext() {
        // func toNext() modifies the value forwards (or backwards) circularly
        enum MyEnum: CaseIterable { case a, b, c }
        var letter = MyEnum.a; XCTAssertEqual(letter, .a)
        letter.toNext(true); XCTAssertEqual(letter, .b)
        letter.toNext(true); XCTAssertEqual(letter, .c)
        letter.toNext(true); XCTAssertEqual(letter, .a)
        letter.toNext(true); XCTAssertEqual(letter, .b)
        letter.toNext(false); XCTAssertEqual(letter, .a)
        letter.toNext(false); XCTAssertEqual(letter, .c)
        letter.toNext(false); XCTAssertEqual(letter, .b)
        letter.toNext(false); XCTAssertEqual(letter, .a)
    }

    func test_func_toNext2() {
        // func toNext() modifies the value forwards (or backwards) circularly
        var side = Windrose.north; XCTAssertEqual(side, .north)
        side.toNext(true); XCTAssertEqual(side, .east)
        side.toNext(true); XCTAssertEqual(side, .south)
        side.toNext(true); XCTAssertEqual(side, .west)
        side.toNext(true); XCTAssertEqual(side, .north)
        side.toNext(true); XCTAssertEqual(side, .east)

        side.toNext(false); XCTAssertEqual(side, .north)
        side.toNext(false); XCTAssertEqual(side, .west)
        side.toNext(false); XCTAssertEqual(side, .south)
        side.toNext(false); XCTAssertEqual(side, .east)
        side.toNext(false); XCTAssertEqual(side, .north)
    }

    func test_property_next() {
        // property next returns the next value (circular)
        var side = Windrose.north; XCTAssertEqual(side, .north)
        side = side.next; XCTAssertEqual(side, .east)
        side = side.next; XCTAssertEqual(side, .south)
        side = side.next; XCTAssertEqual(side, .west)
        side = side.next; XCTAssertEqual(side, .north)
        side = side.next; XCTAssertEqual(side, .east)
    }

    func test_property_prev() {
        // property prev returns the previous value (circular)
        var side = Windrose.north; XCTAssertEqual(side, .north)
        side = side.prev; XCTAssertEqual(side, .west)
        side = side.prev; XCTAssertEqual(side, .south)
        side = side.prev; XCTAssertEqual(side, .east)
        side = side.prev; XCTAssertEqual(side, .north)
        side = side.prev; XCTAssertEqual(side, .west)
    }

    @available(*, deprecated) // silence warnings
    func test_enum_one_case() {
        enum MyEnum0 {} // no cases - cannot create a variable

        enum MyEnum1: CaseIterable, Equatable {
            case oneAndOnly
        }

        var val = MyEnum1.oneAndOnly; XCTAssertEqual(val, .oneAndOnly)
        val.toNext(true); XCTAssertEqual(val, .oneAndOnly)
        val.toNext(false); XCTAssertEqual(val, .oneAndOnly)

        XCTAssertEqual(val.next, .oneAndOnly)
        XCTAssertEqual(val.prev, .oneAndOnly)
    }

    @available(*, deprecated) // silence warnings
    func test_enum_increment() {
        var side = Windrose.north
        XCTAssertEqual(side, .north)
        side.increment(next: true); XCTAssertEqual(side, .east)
        side.increment(next: true); XCTAssertEqual(side, .south)
        side.increment(next: true); XCTAssertEqual(side, .west)
        side.increment(next: true); XCTAssertEqual(side, .north)
        side.increment(next: true); XCTAssertEqual(side, .east)

        side.increment(next: false); XCTAssertEqual(side, .north)
        side.increment(next: false); XCTAssertEqual(side, .west)
        side.increment(next: false); XCTAssertEqual(side, .south)
        side.increment(next: false); XCTAssertEqual(side, .east)
        side.increment(next: false); XCTAssertEqual(side, .north)
        side.increment(next: false); XCTAssertEqual(side, .west)
    }

    @available(*, deprecated) // silence warnings
    func test_enum_incremented() {
        var side = Windrose.north; XCTAssertEqual(side, .north)

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
