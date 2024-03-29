//
//  DateIntervalExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 28.08.20.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import XCTest

class DateIntervalExtTests: XCTestCase {
    override func setUp() {}
    override func tearDown() {}

    func test_DateIntervalExt() {
        let calendar = Calendar.current
        let refDate1 = calendar.date(from: DateComponents(calendar: calendar, year: 2019, month: 9, day: 13, hour: 15))!

        XCTAssertEqual("\(DateInterval(startDate: refDate1, durationHours: 1)!.brief)",
                       "13.09.2019 15:00:00 to 13.09.2019 16:00:00")
        XCTAssertNil(DateInterval(startDate: refDate1, durationHours: 0))
        XCTAssertNil(DateInterval(startDate: refDate1, durationHours: -30))
    }

    func test_DateIntervalExt_1() {
        let calendar = Calendar.current
        let refDate = calendar.date(from: DateComponents(calendar: calendar, year: 2020, month: 1, day: 28, hour: 14))!
        let refOneHourInterval = Calendar.current.dateInterval(of: .hour, for: refDate)!
        let oneHour = refOneHourInterval.duration
        let refOneHourHenceInterval = Calendar.current.dateInterval(of: .hour, for: Date() + oneHour)!

        let intervalA_0_00_to_1_00 = DateInterval(start: refDate, duration: oneHour)
        let intervalB_0_00_to_2_00 = DateInterval(start: refDate, duration: oneHour * 2.0)
        let intervalC_0_30_to_1_30 = DateInterval(start: refDate + oneHour * 0.5, duration: oneHour)
        let intervalD_1_00_to_2_00 = DateInterval(start: refDate + oneHour, duration: oneHour)

        XCTAssertFalse(refOneHourInterval.isInTheFuture)
        XCTAssertTrue(refOneHourHenceInterval.isInTheFuture)

        XCTAssertEqual(intervalA_0_00_to_1_00.durationHours, 1)
        XCTAssertEqual(intervalB_0_00_to_2_00.durationHours, 2)
        XCTAssertEqual(intervalC_0_30_to_1_30.durationHours, 1)
        XCTAssertEqual(intervalD_1_00_to_2_00.durationHours, 1)

        XCTAssertEqual(intervalA_0_00_to_1_00.brief, "28.01.2020 14:00:00 to 28.01.2020 15:00:00")
        XCTAssertEqual(intervalB_0_00_to_2_00.brief, "28.01.2020 14:00:00 to 28.01.2020 16:00:00")
        XCTAssertEqual(intervalC_0_30_to_1_30.brief, "28.01.2020 14:30:00 to 28.01.2020 15:30:00")
        XCTAssertEqual(intervalD_1_00_to_2_00.brief, "28.01.2020 15:00:00 to 28.01.2020 16:00:00")

        XCTAssertTrue(intervalA_0_00_to_1_00.fullyOverlaps(with: intervalA_0_00_to_1_00))
        XCTAssertTrue(intervalA_0_00_to_1_00.fullyOverlaps(with: intervalB_0_00_to_2_00))
        XCTAssertFalse(intervalA_0_00_to_1_00.fullyOverlaps(with: intervalC_0_30_to_1_30))
        XCTAssertFalse(intervalA_0_00_to_1_00.fullyOverlaps(with: intervalD_1_00_to_2_00))

        XCTAssertTrue(intervalB_0_00_to_2_00.fullyOverlaps(with: intervalA_0_00_to_1_00))
        XCTAssertTrue(intervalB_0_00_to_2_00.fullyOverlaps(with: intervalB_0_00_to_2_00))
        XCTAssertTrue(intervalB_0_00_to_2_00.fullyOverlaps(with: intervalC_0_30_to_1_30))
        XCTAssertTrue(intervalB_0_00_to_2_00.fullyOverlaps(with: intervalD_1_00_to_2_00))

        XCTAssertFalse(intervalC_0_30_to_1_30.fullyOverlaps(with: intervalA_0_00_to_1_00))
        XCTAssertTrue(intervalC_0_30_to_1_30.fullyOverlaps(with: intervalB_0_00_to_2_00))
        XCTAssertTrue(intervalC_0_30_to_1_30.fullyOverlaps(with: intervalC_0_30_to_1_30))
        XCTAssertFalse(intervalC_0_30_to_1_30.fullyOverlaps(with: intervalD_1_00_to_2_00))

        XCTAssertFalse(intervalD_1_00_to_2_00.fullyOverlaps(with: intervalA_0_00_to_1_00))
        XCTAssertTrue(intervalD_1_00_to_2_00.fullyOverlaps(with: intervalB_0_00_to_2_00))
        XCTAssertFalse(intervalD_1_00_to_2_00.fullyOverlaps(with: intervalC_0_30_to_1_30))
        XCTAssertTrue(intervalD_1_00_to_2_00.fullyOverlaps(with: intervalD_1_00_to_2_00))

        XCTAssertTrue(intervalA_0_00_to_1_00.partiallyOverlaps(with: intervalA_0_00_to_1_00))
        XCTAssertTrue(intervalA_0_00_to_1_00.partiallyOverlaps(with: intervalB_0_00_to_2_00))
        XCTAssertTrue(intervalA_0_00_to_1_00.partiallyOverlaps(with: intervalC_0_30_to_1_30))
        XCTAssertFalse(intervalA_0_00_to_1_00.partiallyOverlaps(with: intervalD_1_00_to_2_00))

        XCTAssertTrue(intervalB_0_00_to_2_00.partiallyOverlaps(with: intervalA_0_00_to_1_00))
        XCTAssertTrue(intervalB_0_00_to_2_00.partiallyOverlaps(with: intervalB_0_00_to_2_00))
        XCTAssertTrue(intervalB_0_00_to_2_00.partiallyOverlaps(with: intervalC_0_30_to_1_30))
        XCTAssertTrue(intervalB_0_00_to_2_00.partiallyOverlaps(with: intervalD_1_00_to_2_00))

        XCTAssertTrue(intervalC_0_30_to_1_30.partiallyOverlaps(with: intervalA_0_00_to_1_00))
        XCTAssertTrue(intervalC_0_30_to_1_30.partiallyOverlaps(with: intervalB_0_00_to_2_00))
        XCTAssertTrue(intervalC_0_30_to_1_30.partiallyOverlaps(with: intervalC_0_30_to_1_30))
        XCTAssertTrue(intervalC_0_30_to_1_30.partiallyOverlaps(with: intervalD_1_00_to_2_00))

        XCTAssertFalse(intervalD_1_00_to_2_00.partiallyOverlaps(with: intervalA_0_00_to_1_00))
        XCTAssertTrue(intervalD_1_00_to_2_00.partiallyOverlaps(with: intervalB_0_00_to_2_00))
        XCTAssertTrue(intervalD_1_00_to_2_00.partiallyOverlaps(with: intervalC_0_30_to_1_30))
        XCTAssertTrue(intervalD_1_00_to_2_00.partiallyOverlaps(with: intervalD_1_00_to_2_00))
    }

    static let dint = DateInterval(startDate: Date(), durationHours: 3)

    func test_DateIntervalExt_2() {
        // create a test Date
        let testDate = Date(timeIntervalSinceReferenceDate: 625_329_725.286_747)
        let secondsFromUTC = TimeZone.current.secondsFromGMT(for: testDate)
        let testDateUTC = testDate.addingTimeInterval(-TimeInterval(secondsFromUTC))

        XCTAssertEqual(testDateUTC.ddMMyyyy_HHmmss_𝜇s, "2020-10-25 14:42:05.286747")
        XCTAssertEqual(testDateUTC.HHmmssSSS, "14:42:05.287")

        // print using the current time zone
        printClassAndFunc("testDate= \(testDate.ddMMyyyy_HHmmss), testDateUTC= \(testDateUTC.ddMMyyyy_HHmmss)")
        // XCTAssertEqual(

        // test the failable initializer
        // good duration
        XCTAssertEqual("\(DateInterval(startDate: testDateUTC, durationHours: 1)!.brief)",
                       "25.10.2020 14:00:00 to 25.10.2020 15:00:00")

        // bad duration
        XCTAssertNil(DateInterval(startDate: testDateUTC, durationHours: 0))
        XCTAssertNil(DateInterval(startDate: testDateUTC, durationHours: -30))
    }

    func test_DateIntervalExt_3() {
        let calendar = Calendar.current
        let refDate = calendar.date(from: DateComponents(calendar: calendar, year: 2020, month: 1, day: 28, hour: 14))!

        let firstHour = Calendar.current.dateInterval(of: .hour, for: refDate)!
        let oneHour = firstHour.duration
        let firstThreeHours = DateInterval(start: refDate, duration: 3.0 * oneHour)

        let zeroHour = DateInterval(start: refDate - oneHour * 1.0, duration: oneHour)
        let halfHour = DateInterval(start: refDate - oneHour * 0.5, duration: oneHour)
        let secondHour = DateInterval(start: refDate + oneHour, duration: oneHour)
        let fourthHour = DateInterval(start: refDate + oneHour * 4.0, duration: oneHour)

        XCTAssertTrue(firstHour.fullyOverlaps(with: firstThreeHours))
        XCTAssertFalse(firstHour.fullyOverlaps(with: halfHour))

        XCTAssertTrue(firstThreeHours.fullyOverlaps(with: firstHour))
        XCTAssertTrue(firstThreeHours.fullyOverlaps(with: secondHour))

        XCTAssertFalse(firstThreeHours.fullyOverlaps(with: halfHour))
        XCTAssertFalse(firstThreeHours.fullyOverlaps(with: fourthHour))
        XCTAssertFalse(firstThreeHours.fullyOverlaps(with: zeroHour))
    }

    func test_DateIntervalExt_4() {
        // create a test Date
        let testDate = Date(timeIntervalSinceReferenceDate: 625_329_725.286_747)

        let twoYearInterval = DateInterval.twoYearsAround(date: testDate)
        XCTAssertEqual(twoYearInterval.durationHours, (365 + 366) * 24)
    }
}

class DateIntervalTests: XCTestCase {
    func test_DateInterval_operations() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_CH")

        let dateIntervalFormatter = DateIntervalFormatter()
        dateIntervalFormatter.locale = Locale(identifier: "fr_CH")

        func format(interval: DateInterval) -> String {
            return "\(dateIntervalFormatter.string(from: interval)!) [\(interval.duration)]"
        }

        let now = Date()

        let today = Calendar.current.dateInterval(of: .day, for: now)!
        let oneDay = today.duration
        let thisHour = Calendar.current.dateInterval(of: .hour, for: now)!
        let oneHour = thisHour.duration
        let theseThreeHours = DateInterval(start: now.wholeHour!, duration: 3.0 * oneHour)
        let nextHour = DateInterval(start: thisHour.end, duration: oneHour)
        let tomorrow = DateInterval(start: today.end, duration: oneDay)

        let startInThreeQuartersOfHour = DateInterval(start: thisHour.start + oneHour * 0.75, duration: oneHour / 2)

        printClassAndFunc("today \(format(interval: today))")
        printClassAndFunc("thisHour \(format(interval: thisHour))")
        printClassAndFunc("theseThreeHours \(format(interval: theseThreeHours))")
        printClassAndFunc("nextHour \(format(interval: nextHour))")
        printClassAndFunc("tomorrow \(format(interval: tomorrow))")
        printClassAndFunc("startInThreeQuartersOfHour \(format(interval: startInThreeQuartersOfHour))")

        let intersection1 = thisHour.intersection(with: thisHour)!
        dateIntervalFormatter.string(from: intersection1)
        printClassAndFunc("thisHour.intersection(with: thisHour) \(format(interval: intersection1))]")
        printClassAndFunc("thisHour.intersects(thisHour) \(thisHour.intersects(thisHour))")

        let intersection2 = thisHour.intersection(with: nextHour)!
        dateIntervalFormatter.string(from: intersection2)
        printClassAndFunc("thisHour.intersection(nextHour) \(dateIntervalFormatter.string(from: intersection2)!) [\(intersection2.duration)]")
        printClassAndFunc("thisHour.intersects(nextHour) \(thisHour.intersects(nextHour))")

        let intersection3 = thisHour.intersection(with: startInThreeQuartersOfHour)!
        dateIntervalFormatter.string(from: intersection3)
        printClassAndFunc("thisHour.intersection(with: startInThreeQuartersOfHour) \(format(interval: intersection3))]")
        printClassAndFunc("thisHour.intersects(startInThreeQuartersOfHour) \(thisHour.intersects(startInThreeQuartersOfHour))")

        let intersection4 = thisHour.intersection(with: today)!
        dateIntervalFormatter.string(from: intersection4)
        printClassAndFunc("thisHour.intersection(with: today) \(format(interval: intersection4))]")
        printClassAndFunc("thisHour.intersects(today) \(thisHour.intersects(today))")

        if let intersection5 = thisHour.intersection(with: tomorrow) {
            printClassAndFunc("thisHour.intersection(with: tomorrow) \(format(interval: intersection5))]")
        } else {
            printClassAndFunc("thisHour.intersection(tomorrow) == nil")
        }
        printClassAndFunc("thisHour.intersects(tomorrow) \(thisHour.intersects(tomorrow))")

        let intersection6 = thisHour.intersection(with: theseThreeHours)!
        printClassAndFunc("thisHour.intersection(with: theseThreeHours) \(format(interval: intersection6))]")
    }
}
