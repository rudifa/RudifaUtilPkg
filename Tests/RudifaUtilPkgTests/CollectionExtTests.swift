//
//  CollectionUtilTests.swift v.0.2.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 24.12.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import XCTest

// a sample struct for testing the Array extension methods
struct CalendarData: Codable, Equatable {
    let title: String
    var hidden: Bool = false

    var string: String {
        let hivi = hidden ? "hidden" : "visible"
        return "\(title) \(hivi)"
    }

    /// Strict equality comparison
    /// - Parameters:
    ///   - lhs: first comparand
    ///   - rhs: second comparand
    /// - Returns: true if comparands are strictly equal
    static func == (lhs: CalendarData, rhs: CalendarData) -> Bool {
        return lhs.title == rhs.title && lhs.hidden == rhs.hidden
    }

    /// Partial equality comparison
    /// - Parameters:
    ///   - lhs: first comparand
    ///   - rhs: second comparand
    /// - Returns: true if comparands have the same tutle
    static func sameTitle(lhs: CalendarData, rhs: CalendarData) -> Bool {
        return lhs.title == rhs.title
    }
}

struct MockCalendar {
    let title: String
    let otherData = Date()
}

class CollectionUtilTests: XCTestCase {
    override func setUp() {}
    override func tearDown() {}

    func test_updatedPreservingOrder_1() {
        // test func updatedPreservingOrder(from other: Array) -> [Element] on [Int]

        let aaa = [5, 4, 3, 2, 1]

        XCTAssertEqual(aaa.updatedPreservingOrder(from: aaa), [5, 4, 3, 2, 1])
        XCTAssertEqual(aaa.updatedPreservingOrder(from: [1, 2, 3, 4, 5]), [5, 4, 3, 2, 1])
        XCTAssertEqual(aaa.updatedPreservingOrder(from: [1, 2, 3, 4, 5, 6, 7]), [5, 4, 3, 2, 1, 6, 7])
        XCTAssertEqual(aaa.updatedPreservingOrder(from: [3, 4, 5, 6, 7]), [5, 4, 3, 6, 7])
        XCTAssertEqual(aaa.updatedPreservingOrder(from: [6, 7]), [6, 7])
    }

    func test_updatePreservingOrder_2() {
        // test func updatedPreservingOrder(from other: Array) -> [Element] on [CalendarData]

        struct MockCalendar {
            let title: String
            let otherData = Date()
        }

        var calendarDataArray = [CalendarData(title: "Newbie", hidden: false),
                                 CalendarData(title: "Oldie", hidden: true)]

        printClassAndFunc(info: "original calendarDataArray= \(calendarDataArray.map { $0.string })")

        let incomingCalendars = [MockCalendar(title: "Newbie"),
                                 MockCalendar(title: "Oldie"),
                                 MockCalendar(title: "Pretty")]

        // emulate the operation in SharedUserDefaults.updateCalendarsAndSelection
        calendarDataArray = calendarDataArray.updatedPreservingOrder(from: incomingCalendars.map { CalendarData(title: $0.title) })

        printClassAndFunc(info: "updated calendarDataArray= \(calendarDataArray.map { $0.string })")
    }

    func test_updatePreservingOrder_3() {
        // test func updatedPreservingOrder(from other: Array, predicate: (Element, Element) -> Bool) -> [Element] on CalendarData

        let calendarDataArray = [CalendarData(title: "Alice", hidden: false),
                                 CalendarData(title: "Bobby", hidden: true),
                                 CalendarData(title: "Charlie", hidden: false),
                                 CalendarData(title: "Debbie", hidden: true)]

        let incomingCalendars = [MockCalendar(title: "Newbie"),
                                 MockCalendar(title: "Oldie"),
                                 MockCalendar(title: "Pretty"),
                                 MockCalendar(title: "Charlie"),
                                 MockCalendar(title: "Bobby")]

        let incomingCalendarDataArray = incomingCalendars.map { CalendarData(title: $0.title) }

        let expectedResultStringArray = ["Bobby hidden", "Charlie visible", "Newbie visible", "Oldie visible", "Pretty visible"]

        do {
            /// Predicate for updatedPreservingOrder
            /// - Parameters:
            ///   - elt1: element from the first array
            ///   - elt2: element from the other array
            /// - Returns: boolean result
            func sameTitle(elt1: CalendarData, elt2: CalendarData) -> Bool {
                return elt1.title == elt2.title
            }

            // using the supplied predicate
            let updatedCalendarDataArray = calendarDataArray.updatedPreservingOrder(from: incomingCalendarDataArray,
                                                                                    predicate: sameTitle)

            printClassAndFunc(info: "updatedCalendarDataArray= \(updatedCalendarDataArray.map { $0.string })")
            XCTAssertEqual(updatedCalendarDataArray.map { $0.string }, expectedResultStringArray)
        }

        do {
            // using the inline predicate
            let updatedCalendarDataArray = calendarDataArray.updatedPreservingOrder(from: incomingCalendarDataArray,
                                                                                    predicate: { (elt1, elt2) -> Bool in elt1.title == elt2.title })

            printClassAndFunc(info: "updatedCalendarDataArray= \(updatedCalendarDataArray.map { $0.string })")
            XCTAssertEqual(updatedCalendarDataArray.map { $0.string }, expectedResultStringArray)
        }

        do {
            // using the predicate provided by the class
            let updatedCalendarDataArray = calendarDataArray.updatedPreservingOrder(from: incomingCalendarDataArray,
                                                                                    predicate: CalendarData.sameTitle)

            printClassAndFunc(info: "updatedCalendarDataArray= \(updatedCalendarDataArray.map { $0.string })")
            XCTAssertEqual(updatedCalendarDataArray.map { $0.string }, expectedResultStringArray)
        }
    }
}
