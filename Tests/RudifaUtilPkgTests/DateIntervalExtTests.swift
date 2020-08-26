//
//  DateIntervalExtTests.swift v.0.1.0
//  RudifaUtilPkg
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
}

/*
 extension DateInterval {
 /// Returns true if self fully overlaps with interval
 /// - Parameter interval: interval to compare with
 public func fullyOverlaps(with interval: DateInterval) -> Bool {
     if let intersection = self.intersection(with: interval) {
         if intersection.duration >= min(duration, interval.duration) {
             return true
         }
     }
     return false
 }

 /// Returns true if self partially overlaps with interval
 /// - Parameter interval: interval to compare with
 public func partiallyOverlaps(with interval: DateInterval) -> Bool {
     if let intersection = self.intersection(with: interval) {
         if intersection.duration > 0.0 {
             return true
         }
     }
     return false
 }

 /// Returns the duration in hours, truncated to the nearest lower integer
 public var durationHours: Int {
     return Int(floor(duration / 3600.0))
 }

 /// Returns true if the interval is fully in the future, false otherwise
 public var isInTheFuture: Bool {
     return start > Date()
 }

 public var brief: String {
     "\(start.ddMMyyyy_HHmmss) to \(end.ddMMyyyy_HHmmss)"
 }
 }
 */
