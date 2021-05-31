//
//  CollectionExtTests.swift v.0.6.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 24.12.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import XCTest

// MARK: sample structs for testing the Array extension methods

struct MockCalendarData: Codable, Equatable {
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
    static func == (lhs: MockCalendarData, rhs: MockCalendarData) -> Bool {
        return lhs.title == rhs.title && lhs.hidden == rhs.hidden
    }

    /// Partial equality comparison
    /// - Parameters:
    ///   - lhs: first comparand
    ///   - rhs: second comparand
    /// - Returns: true if comparands have the same title
    static func sameTitle(lhs: MockCalendarData, rhs: MockCalendarData) -> Bool {
        return lhs.title == rhs.title
    }

    /// Partial equality comparison
    /// - Parameter other: the instance to compare to
    /// - Returns: true if other has the same title
    func sameTitle(as other: MockCalendarData) -> Bool {
        return title == other.title
    }
}

struct MockCalendar {
    let title: String
    let otherData = Date()
}

class CollectionExtTests: XCTestCase {
    override func setUp() {}
    override func tearDown() {}

    func test_updatedPreservingOrder_1A() {
        // func updatedPreservingOrder(from other: Array) -> [Element]
        // returns an updated array

        let array = [5, 4, 3, 2, 1]

        XCTAssertEqual(array.updatedPreservingOrder(from: array), [5, 4, 3, 2, 1])
        XCTAssertEqual(array.updatedPreservingOrder(from: [1, 2, 3, 4, 5]), [5, 4, 3, 2, 1])
        XCTAssertEqual(array.updatedPreservingOrder(from: [1, 2, 3, 4, 5, 6, 7]), [5, 4, 3, 2, 1, 6, 7])
        XCTAssertEqual(array.updatedPreservingOrder(from: [3, 4, 5, 6, 7]), [5, 4, 3, 6, 7])
        XCTAssertEqual(array.updatedPreservingOrder(from: [6, 7, 3]), [3, 6, 7])
    }

    func test_updatedPreservingOrder_1B() {
        // mutating func updatePreservingOrder(from other: Array)
        // updates array in-place

        var array = [5, 4, 3, 2, 1]

        array.updatePreservingOrder(from: array); XCTAssertEqual(array, [5, 4, 3, 2, 1])
        array.updatePreservingOrder(from: [1, 2, 3, 4, 5]); XCTAssertEqual(array, [5, 4, 3, 2, 1])
        array.updatePreservingOrder(from: [1, 2, 3, 4, 5, 6, 7]); XCTAssertEqual(array, [5, 4, 3, 2, 1, 6, 7])
        array.updatePreservingOrder(from: [3, 4, 5, 6, 7]); XCTAssertEqual(array, [5, 4, 3, 6, 7])
        array.updatePreservingOrder(from: [6, 7, 3]); XCTAssertEqual(array, [3, 6, 7])
    }

    func test_updatePreservingOrder_2() {
        // func updatedPreservingOrder(from other: Array) -> [Element]
        // returns an updated array

        // mutating func updatePreservingOrder(from other: Array)
        // updates array in-place

        struct MockCalendar {
            let title: String
            let otherData = Date()
        }

        var calendarDataArray = [MockCalendarData(title: "Newbie", hidden: false),
                                 MockCalendarData(title: "Oldie", hidden: true)]

        printClassAndFunc(info: "original calendarDataArray= \(calendarDataArray.map { $0.string })")

        let incomingCalendars = [MockCalendar(title: "Newbie"),
                                 MockCalendar(title: "Oldie"),
                                 MockCalendar(title: "Pretty")]

        let incomingCalendarDataArray = incomingCalendars.map { MockCalendarData(title: $0.title) }

        let expectedResultStringArray = ["Newbie visible", "Oldie visible", "Pretty visible"]

        let updatedCalendarDataArray = calendarDataArray.updatedPreservingOrder(from: incomingCalendarDataArray)

        printClassAndFunc(info: "updated calendarDataArray= \(calendarDataArray.map { $0.string })")
        XCTAssertEqual(updatedCalendarDataArray.map { $0.string }, expectedResultStringArray)

        calendarDataArray.updatePreservingOrder(from: incomingCalendarDataArray)
        XCTAssertEqual(calendarDataArray.map { $0.string }, expectedResultStringArray)
    }

    func test_updatePreservingOrder_3() {
        // func updatedPreservingOrder(from other: Array, predicate: (Element, Element) -> Bool) -> [Element]
        // returns an updated array

        // mutating func updatePreservingOrder(from other: Array, predicate: (Element, Element) -> Bool)
        // updates array in-place

        let calendarDataArray = [MockCalendarData(title: "Alice", hidden: false),
                                 MockCalendarData(title: "Bobby", hidden: true),
                                 MockCalendarData(title: "Charlie", hidden: false),
                                 MockCalendarData(title: "Debbie", hidden: true)]

        let incomingCalendars = [MockCalendar(title: "Newbie"),
                                 MockCalendar(title: "Oldie"),
                                 MockCalendar(title: "Pretty"),
                                 MockCalendar(title: "Charlie"),
                                 MockCalendar(title: "Bobby")]

        let incomingCalendarDataArray = incomingCalendars.map { MockCalendarData(title: $0.title) }

        let expectedResultStringArray = ["Bobby hidden", "Charlie visible", "Newbie visible", "Oldie visible", "Pretty visible"]

        do {
            /// Predicate for updatedPreservingOrder
            /// - Parameters:
            ///   - elt1: element from the first array
            ///   - elt2: element from the other array
            /// - Returns: boolean result
            func sameTitle(elt1: MockCalendarData, elt2: MockCalendarData) -> Bool {
                return elt1.title == elt2.title
            }

            // using the supplied predicate

            let updatedCalendarDataArray = calendarDataArray.updatedPreservingOrder(from: incomingCalendarDataArray,
                                                                                    predicate: sameTitle)

            printClassAndFunc(info: "updatedCalendarDataArray= \(updatedCalendarDataArray.map { $0.string })")
            XCTAssertEqual(updatedCalendarDataArray.map { $0.string }, expectedResultStringArray)

            var localCopy = calendarDataArray
            localCopy.updatePreservingOrder(from: incomingCalendarDataArray,
                                            predicate: sameTitle)
            XCTAssertEqual(localCopy.map { $0.string }, expectedResultStringArray)
        }

        do {
            // using the inline predicate

            let updatedCalendarDataArray = calendarDataArray.updatedPreservingOrder(from: incomingCalendarDataArray,
                                                                                    predicate: { (elt1, elt2) -> Bool in elt1.title == elt2.title })

            printClassAndFunc(info: "updatedCalendarDataArray= \(updatedCalendarDataArray.map { $0.string })")
            XCTAssertEqual(updatedCalendarDataArray.map { $0.string }, expectedResultStringArray)

            var localCopy = calendarDataArray
            localCopy.updatePreservingOrder(from: incomingCalendarDataArray,
                                            predicate: { (elt1, elt2) -> Bool in elt1.title == elt2.title })
            XCTAssertEqual(localCopy.map { $0.string }, expectedResultStringArray)
        }

        do {
            // using the predicate provided by the class

            let updatedCalendarDataArray = calendarDataArray.updatedPreservingOrder(from: incomingCalendarDataArray,
                                                                                    predicate: MockCalendarData.sameTitle)

            printClassAndFunc(info: "updatedCalendarDataArray= \(updatedCalendarDataArray.map { $0.string })")
            XCTAssertEqual(updatedCalendarDataArray.map { $0.string }, expectedResultStringArray)

            var localCopy = calendarDataArray
            localCopy.updatePreservingOrder(from: incomingCalendarDataArray,
                                            predicate: MockCalendarData.sameTitle)
            XCTAssertEqual(localCopy.map { $0.string }, expectedResultStringArray)
        }
    }

    func test_move_element_atIndex_to_index() {
        // mutating func move(atIndex old: Index, toIndex new: Index)
        // moves the element updating the array in-place

        var array = ["A", "B", "C", "D"]

        array.move(atIndex: 3, toIndex: 0); XCTAssertEqual(array, ["D", "A", "B", "C"])
        array.move(atIndex: 0, toIndex: 1); XCTAssertEqual(array, ["A", "D", "B", "C"])
        array.move(atIndex: 1, toIndex: 2); XCTAssertEqual(array, ["A", "B", "D", "C"])
        array.move(atIndex: 2, toIndex: 3); XCTAssertEqual(array, ["A", "B", "C", "D"])
        array.move(atIndex: 3, toIndex: 4); XCTAssertEqual(array, ["A", "B", "C", "D"])

        array.move(atIndex: 0, toIndex: 0); XCTAssertEqual(array, ["A", "B", "C", "D"])
        array.move(atIndex: 0, toIndex: 1); XCTAssertEqual(array, ["B", "A", "C", "D"])
        array.move(atIndex: 1, toIndex: 2); XCTAssertEqual(array, ["B", "C", "A", "D"])
        array.move(atIndex: 2, toIndex: 3); XCTAssertEqual(array, ["B", "C", "D", "A"])
        array.move(atIndex: 3, toIndex: 4); XCTAssertEqual(array, ["B", "C", "D", "A"])

        array.move(atIndex: 42, toIndex: 3); XCTAssertEqual(array, ["B", "C", "D", "A"])
    }

    func test_move_element_to_index() {
        // mutating func move(element: Element, to index: Index)
        // moves the element updating the array in-place

        var array = ["A", "B", "C", "D"]

        array.move(element: "D", to: 0); XCTAssertEqual(array, ["D", "A", "B", "C"])
        array.move(element: "D", to: 1); XCTAssertEqual(array, ["A", "D", "B", "C"])
        array.move(element: "D", to: 2); XCTAssertEqual(array, ["A", "B", "D", "C"])
        array.move(element: "D", to: 3); XCTAssertEqual(array, ["A", "B", "C", "D"])
        array.move(element: "D", to: 4); XCTAssertEqual(array, ["A", "B", "C", "D"])

        array.move(element: "A", to: 0); XCTAssertEqual(array, ["A", "B", "C", "D"])
        array.move(element: "A", to: 1); XCTAssertEqual(array, ["B", "A", "C", "D"])
        array.move(element: "A", to: 2); XCTAssertEqual(array, ["B", "C", "A", "D"])
        array.move(element: "A", to: 3); XCTAssertEqual(array, ["B", "C", "D", "A"])
        array.move(element: "A", to: 4); XCTAssertEqual(array, ["B", "C", "D", "A"])

        array.move(element: "Q", to: 3); XCTAssertEqual(array, ["B", "C", "D", "A"])
    }

    func test_moved_element_at_to_index() {
        // func moved(atIndex old: Index, toIndex new: Index) -> [Element]
        // returns a copy of array, with the element moved

        let array = ["A", "B", "C", "D"]

        XCTAssertEqual(array.moved(atIndex: 3, toIndex: 0), ["D", "A", "B", "C"])
        XCTAssertEqual(array.moved(atIndex: 3, toIndex: 1), ["A", "D", "B", "C"])
        XCTAssertEqual(array.moved(atIndex: 3, toIndex: 2), ["A", "B", "D", "C"])
        XCTAssertEqual(array.moved(atIndex: 3, toIndex: 3), ["A", "B", "C", "D"])
        XCTAssertEqual(array.moved(atIndex: 3, toIndex: 4), ["A", "B", "C", "D"])

        XCTAssertEqual(array.moved(atIndex: 0, toIndex: 0), ["A", "B", "C", "D"])
        XCTAssertEqual(array.moved(atIndex: 0, toIndex: 1), ["B", "A", "C", "D"])
        XCTAssertEqual(array.moved(atIndex: 0, toIndex: 2), ["B", "C", "A", "D"])
        XCTAssertEqual(array.moved(atIndex: 0, toIndex: 3), ["B", "C", "D", "A"])
        XCTAssertEqual(array.moved(atIndex: 0, toIndex: 4), ["A", "B", "C", "D"])

        XCTAssertEqual(array.moved(atIndex: 42, toIndex: 4), ["A", "B", "C", "D"])
    }

    func test_moved_element_to_index() {
        // func moved(element: Element, to index: Index) -> [Element]
        // returns a copy of array, with the element moved

        let array = ["A", "B", "C", "D"]

        XCTAssertEqual(array.moved(element: "D", to: 0), ["D", "A", "B", "C"])
        XCTAssertEqual(array.moved(element: "D", to: 1), ["A", "D", "B", "C"])
        XCTAssertEqual(array.moved(element: "D", to: 2), ["A", "B", "D", "C"])
        XCTAssertEqual(array.moved(element: "D", to: 3), ["A", "B", "C", "D"])
        XCTAssertEqual(array.moved(element: "D", to: 4), ["A", "B", "C", "D"])

        XCTAssertEqual(array.moved(element: "A", to: 0), ["A", "B", "C", "D"])
        XCTAssertEqual(array.moved(element: "A", to: 1), ["B", "A", "C", "D"])
        XCTAssertEqual(array.moved(element: "A", to: 2), ["B", "C", "A", "D"])
        XCTAssertEqual(array.moved(element: "A", to: 3), ["B", "C", "D", "A"])
        XCTAssertEqual(array.moved(element: "A", to: 4), ["A", "B", "C", "D"])

        XCTAssertEqual(array.moved(element: "Q", to: 4), ["A", "B", "C", "D"])
    }

    func test_move_where() {
        // mutating func move(where predicate: (Element) -> Bool, to index: Index)
        // moves the element matching the predicate, updating the array in-place

        var array = [MockCalendarData(title: "Anemone", hidden: false),
                     MockCalendarData(title: "Begonia", hidden: true),
                     MockCalendarData(title: "Clematis", hidden: false),
                     MockCalendarData(title: "Dahlia", hidden: true)]

        array.move(where: MockCalendarData(title: "Dahlia").sameTitle, to: 0); XCTAssertEqual(array.map { $0.title }, ["Dahlia", "Anemone", "Begonia", "Clematis"])
        array.move(where: MockCalendarData(title: "Dahlia").sameTitle, to: 1); XCTAssertEqual(array.map { $0.title }, ["Anemone", "Dahlia", "Begonia", "Clematis"])
        array.move(where: MockCalendarData(title: "Dahlia").sameTitle, to: 2); XCTAssertEqual(array.map { $0.title }, ["Anemone", "Begonia", "Dahlia", "Clematis"])
        array.move(where: MockCalendarData(title: "Dahlia").sameTitle, to: 3); XCTAssertEqual(array.map { $0.title }, ["Anemone", "Begonia", "Clematis", "Dahlia"])

        array.move(where: MockCalendarData(title: "Anemone").sameTitle, to: 0); XCTAssertEqual(array.map { $0.title }, ["Anemone", "Begonia", "Clematis", "Dahlia"])
        array.move(where: MockCalendarData(title: "Anemone").sameTitle, to: 1); XCTAssertEqual(array.map { $0.title }, ["Begonia", "Anemone", "Clematis", "Dahlia"])
        array.move(where: MockCalendarData(title: "Anemone").sameTitle, to: 2); XCTAssertEqual(array.map { $0.title }, ["Begonia", "Clematis", "Anemone", "Dahlia"])
        array.move(where: MockCalendarData(title: "Anemone").sameTitle, to: 3); XCTAssertEqual(array.map { $0.title }, ["Begonia", "Clematis", "Dahlia", "Anemone"])

        array.move(where: MockCalendarData(title: "Orchid").sameTitle, to: 0); XCTAssertEqual(array.map { $0.title }, ["Begonia", "Clematis", "Dahlia", "Anemone"])
    }

    func test_moved_where() {
        // func moved(where predicate: (Element) -> Bool, to index: Index) -> [Element]
        // returns a copy of array, with the element that matched pthe predicate moved

        let array = [MockCalendarData(title: "Anemone", hidden: false),
                     MockCalendarData(title: "Begonia", hidden: true),
                     MockCalendarData(title: "Clematis", hidden: false),
                     MockCalendarData(title: "Dahlia", hidden: true)]

        XCTAssertEqual(array.moved(where: MockCalendarData(title: "Dahlia").sameTitle, to: 0).map { $0.title }, ["Dahlia", "Anemone", "Begonia", "Clematis"])
        XCTAssertEqual(array.moved(where: MockCalendarData(title: "Dahlia").sameTitle, to: 1).map { $0.title }, ["Anemone", "Dahlia", "Begonia", "Clematis"])
        XCTAssertEqual(array.moved(where: MockCalendarData(title: "Dahlia").sameTitle, to: 2).map { $0.title }, ["Anemone", "Begonia", "Dahlia", "Clematis"])
        XCTAssertEqual(array.moved(where: MockCalendarData(title: "Dahlia").sameTitle, to: 3).map { $0.title }, ["Anemone", "Begonia", "Clematis", "Dahlia"])

        XCTAssertEqual(array.moved(where: MockCalendarData(title: "Anemone").sameTitle, to: 0).map { $0.title }, ["Anemone", "Begonia", "Clematis", "Dahlia"])
        XCTAssertEqual(array.moved(where: MockCalendarData(title: "Anemone").sameTitle, to: 1).map { $0.title }, ["Begonia", "Anemone", "Clematis", "Dahlia"])
        XCTAssertEqual(array.moved(where: MockCalendarData(title: "Anemone").sameTitle, to: 2).map { $0.title }, ["Begonia", "Clematis", "Anemone", "Dahlia"])
        XCTAssertEqual(array.moved(where: MockCalendarData(title: "Anemone").sameTitle, to: 3).map { $0.title }, ["Begonia", "Clematis", "Dahlia", "Anemone"])

        XCTAssertEqual(array.moved(where: MockCalendarData(title: "Orchid").sameTitle, to: 3).map { $0.title }, ["Anemone", "Begonia", "Clematis", "Dahlia"])
    }
}
