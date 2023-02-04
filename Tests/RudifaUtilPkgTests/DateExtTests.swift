//
//  DateExtTests.swift.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 18.06.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

@testable import RudifaUtilPkg
import XCTest

class DateExtTests: XCTestCase {
    func test_MillisecondTimestamps() {
        do {
            let date = Date(timeIntervalSince1970: 1_675_373_197.591)
            printClassAndFunc("date: \(date.ddMMyyyy_HHmmss_𝜇s) \(date.millisecondsSince1970)")
            XCTAssertEqual(date.millisecondsSince1970, 1_675_373_197_591)
            XCTAssertEqual(date.iso8601UTC, "2023-02-02T21:26:37Z")
        }
    }

    func test_TimeZoneFeatures() {
        let tzCurrent = TimeZone.current
        print("--- tzCurrent=\(tzCurrent)") // --- tzCurrent=Europe/Zurich (current)
        print("--- timeZoneDataVersion=\(TimeZone.timeZoneDataVersion)") // 2019b
        let tzUTC = TimeZone(identifier: "UTC")
        print("--- tzUTC=\(String(describing: tzUTC))") // --- tzUTC=Optional(GMT (fixed))

        let date = Date()
        let tzCurrentDiffSeconds = tzCurrent.secondsFromGMT(for: date)
        print("--- tzCurrentDiffSeconds=\(tzCurrentDiffSeconds)") // --- tzCurrentDiffSeconds=7200 as of 18 Aug 2019
        let tzUTCDiffSeconds = tzUTC!.secondsFromGMT(for: date)
        print("--- tzUTCDiffSeconds=\(tzUTCDiffSeconds)") // --- tzUTCDiffSeconds=0 // always
        XCTAssertEqual(tzUTCDiffSeconds, 0)
    }

    func test_CalendarFeatures() {
        // see https://nshipster.com/datecomponents/
        // DateComponents is a useful, but ambiguous type.
        // Taken in one context, date components can be used to represent a specific calendar date. But in another context, the same object might instead be used as a duration of time. For example, a date components object with year set to 2018, month set to 10, and day set to 10 could represent a period of 2018 years, 10 months, and 10 days or the tenth day of the tenth month in the year 2018.

        let calendar = Calendar.current
        // Date from DateComponents
        let dateComponents = DateComponents(timeZone: TimeZone.current, year: 2018, month: 6, day: 15, hour: 10)
        let date1 = Calendar.current.date(from: dateComponents)!
        XCTAssertEqual([date1.EEEEddMMyyyy, date1.HHmmss], ["Friday 15.06.2018", "10:00:00"])

        // Date interval - start and end of month for date1
        let dateIntervalOfMonth = calendar.dateInterval(of: .month, for: date1)
        let startOfMonth = dateIntervalOfMonth!.start
        let endOfMonth = dateIntervalOfMonth!.end
        XCTAssertEqual([startOfMonth.EEEEddMMyyyy, startOfMonth.HHmmss], ["Friday 01.06.2018", "00:00:00"])
        XCTAssertEqual([endOfMonth.EEEEddMMyyyy, endOfMonth.HHmmss], ["Sunday 01.07.2018", "00:00:00"])

        // DateComponents as a duration of time
        let date2 = Calendar.current.date(byAdding: DateComponents(year: 1), to: date1)!
        XCTAssertEqual([date2.EEEEddMMyyyy, date2.HHmmss], ["Saturday 15.06.2019", "10:00:00"])

        // Symbols
        let monthSymbols = Calendar.current.monthSymbols
        XCTAssertEqual(monthSymbols, ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"])
        let weekdaySymbols = Calendar.current.weekdaySymbols
        XCTAssertEqual(weekdaySymbols, ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"])
        let weekdaySymbols_M0 = Calendar.current.weekdaySymbols_M0
        XCTAssertEqual(weekdaySymbols_M0, ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
    }

    @available(*, deprecated) // silence warnings re MMMM_yyyy
    func test_ExtendedDateFormats() {
        let date = Date()
        print("--- date=", date, "ddMMyyy=", date.ddMMyyyy)
        print("--- time=", date, "HHmmss=", date.HHmmss)
        print("--- Today \(date.EEEEddMMyyyy) at \(date.HHmmss) tag= \(date.timeTag)")

        do {
            // set an arbitrary date
            let testDate = Date(timeIntervalSince1970: -1_006_344_000)
            let secondsFromUTC = TimeZone.current.secondsFromGMT(for: testDate)
            // get the corresponding date-time in UTC
            // so that the following tests become independent of the current time zone where tests are executed
            let testDateUTC = testDate.addingTimeInterval(-TimeInterval(secondsFromUTC))
            XCTAssertEqual("10.02.1938", testDateUTC.ddMMyyyy)
            XCTAssertEqual("12:00:00", testDateUTC.HHmmss)
            XCTAssertEqual("12:00:00.000", testDateUTC.HHmmssSSS)
            XCTAssertEqual("February 1938", testDateUTC.MMMM_yyyy)
            print("--- Once upon a time", testDateUTC.ddMMyyyy, "at", testDate.HHmmss, "...")

            // test more extended formats
            XCTAssertEqual("12:00:00", testDateUTC.HHmmss)
            XCTAssertEqual("12:00", testDateUTC.HHmm)
            XCTAssertEqual("10.02.1938 12:00:00", testDateUTC.ddMMyyyy_HHmmss)
            XCTAssertEqual("10.02.1938 12:00", testDateUTC.ddMMyyyy_HHmm)
            XCTAssertEqual("Thursday 10.02.1938 12:00:00", testDateUTC.EEEE_ddMMyyyy_HHmmss)
            XCTAssertEqual("Thursday 10.02.1938 12:00", testDateUTC.EEEE_ddMMyyyy_HHmm)
        }
        do {
            // create a test Date
            let testDate = Date(timeIntervalSinceReferenceDate: 625_329_725.286_747)
            let secondsFromUTC = TimeZone.current.secondsFromGMT(for: testDate)
            let testDateUTC = testDate.addingTimeInterval(-TimeInterval(secondsFromUTC))

            XCTAssertEqual(testDateUTC.ddMMyyyy_HHmmss_𝜇s, "2020-10-25 14:42:05.286747")
            XCTAssertEqual(testDateUTC.HHmmssSSS, "14:42:05.287")
        }
    }

    func testInit() {
        let date = Date(seconds: 0)
        XCTAssertEqual(date, Date(timeIntervalSinceReferenceDate: 0))
        XCTAssertEqual(date.ddMMyyyy, "01.01.2001")
    }

    func test_ISO8601Format() {
        // string to date
        let string = "2018-04-20T14:20:00-07:00"
        guard let date = Date(iso8601String: string) else {
            XCTFail()
            return
        }
        XCTAssertEqual(date, Date(timeIntervalSince1970: 1_524_259_200.0))

        // date to string
        let string2 = date.iso8601UTC
        XCTAssertEqual(string2, "2018-04-20T21:20:00Z")

        let string3 = date.iso8601Local
        printClassAndFunc("\(string2) \(string3)")
    }

    func testTimeStampAndTag() {
        let date = Date(seconds: 0)
        XCTAssertEqual(date.timeStamp, 978_307_200.0)
        XCTAssertEqual(date.timeTag, "978307200_00000")
    }

    func test_ExtendedDateModsAndProps() {
        // create date1 from components, decompose and compare
        let d1Comp = DateComponents(timeZone: TimeZone.current, year: 2019, month: 7, day: 26, hour: 10)
        var d1 = Calendar.current.date(from: d1Comp)!

        // test properties of date d1
        XCTAssertEqual([d1.year, d1.month, d1.month_0, d1.day, d1.day_0, d1.weekday, d1.weekday_0M, d1.daysInMonth.count],
                       [2019, 7, 6, 26, 25, 6, 4, 31])

        XCTAssertEqual([d1.EEEEddMMyyyy, String(d1.day), String(d1.day_0)], ["Friday 26.07.2019", "26", "25"])

        XCTAssertEqual("\(d1.wholeHour!.ddMMyyyy) \(d1.wholeHour!.HHmmss)", "26.07.2019 10:00:00")
        XCTAssertEqual("\(d1.wholeDay!.ddMMyyyy) \(d1.wholeDay!.HHmmss)", "26.07.2019 00:00:00")
        XCTAssertEqual("\(d1.wholeMonth!.ddMMyyyy) \(d1.wholeMonth!.HHmmss)", "01.07.2019 00:00:00")

        // test first of the month for date d1
        XCTAssertEqual([d1.month1st.EEEEddMMyyyy, String(d1.month1stWeekday), String(d1.month1stWeekday_0M)], ["Monday 01.07.2019", "2", "0"])
        XCTAssertEqual([d1.month1st.EEEEddMMyyyy, String(d1.month1st.weekday), String(d1.month1st.weekday_0M)], ["Monday 01.07.2019", "2", "0"])

        // test last of the month for date d1
        XCTAssertEqual([d1.monthLast.EEEEddMMyyyy, d1.monthLast.HHmmssSSS, String(d1.month1stWeekday), String(d1.month1stWeekday_0M)], ["Wednesday 31.07.2019", "00:00:00.000", "2", "0"])
        XCTAssertEqual([d1.monthLast.EEEEddMMyyyy, d1.monthLast.HHmmssSSS, String(d1.month1st.weekday), String(d1.month1st.weekday_0M)], ["Wednesday 31.07.2019", "00:00:00.000", "2", "0"])

        // test first of the next month for date d1
        var d1_month1st = d1.month1st
        d1_month1st.nextMonth()
        XCTAssertEqual([d1_month1st.month1st.EEEEddMMyyyy, d1.monthLast.HHmmssSSS, String(d1_month1st.month1stWeekday), String(d1_month1st.month1stWeekday_0M)], ["Thursday 01.08.2019", "00:00:00.000", "5", "3"])

        do {
            // decrement d1 by 1 day and test properties
            let d2 = d1.incremented(by: .day, times: -1)
            XCTAssertEqual([d2.EEEEddMMyyyy, String(d2.month1stWeekday), String(d2.month1stWeekday_0M)], ["Thursday 25.07.2019", "2", "0"])
            d1.increment(by: .day, times: -1)
            XCTAssertEqual([d1.EEEEddMMyyyy, String(d1.month1stWeekday), String(d1.month1stWeekday_0M)], ["Thursday 25.07.2019", "2", "0"])
            XCTAssertEqual([d1.EEEEddMMyyyy, String(d1.day), String(d1.day_0)], ["Thursday 25.07.2019", "25", "24"])
        }
        do {
            // decrement d1 by 1 day and test properties
            let d2 = d1.incremented(by: .day, times: -1)
            XCTAssertEqual(d2.EEEE_ddMMyyyy_HHmmss, "Wednesday 24.07.2019 10:00:00")
            d1.increment(by: .day, times: -1)
            XCTAssertEqual(d2.EEEE_ddMMyyyy_HHmmss, "Wednesday 24.07.2019 10:00:00")
            d1.increment(by: .day, times: +1)
            XCTAssertEqual(d1.EEEE_ddMMyyyy_HHmmss, "Thursday 25.07.2019 10:00:00")
        }

        // decrement d1 by 22 days and test properties
        d1.increment(by: .day, times: -22)
        XCTAssertEqual([d1.EEEEddMMyyyy, String(d1.day), String(d1.day_0)], ["Wednesday 03.07.2019", "3", "2"])

        // d1 fast forward to March 2020
        for _ in 1 ... 8 { d1.nextMonth() }
        XCTAssertEqual(d1.year, 2020); XCTAssertEqual(d1.month, 3); XCTAssertEqual(d1.daysInMonth.count, 31)
        XCTAssertEqual([d1.EEEEddMMyyyy, String(d1.day), String(d1.day_0)], ["Tuesday 03.03.2020", "3", "2"])

        // d1 back to February 2020
        d1.prevMonth()
        XCTAssertEqual(d1.year, 2020); XCTAssertEqual(d1.month, 2); XCTAssertEqual(d1.daysInMonth.count, 29)
        XCTAssertEqual([d1.EEEEddMMyyyy, String(d1.day), String(d1.day_0)], ["Monday 03.02.2020", "3", "2"])

        // d1 faster back to February 2019
        d1.increment(by: .year, times: -1)
        XCTAssertEqual(d1.year, 2019); XCTAssertEqual(d1.month, 2); XCTAssertEqual(d1.daysInMonth.count, 28)
        XCTAssertEqual([d1.EEEEddMMyyyy, String(d1.day), String(d1.day_0)], ["Sunday 03.02.2019", "3", "2"])

        // isToday?
        var dd = Date()
        XCTAssertTrue(dd.isToday)
        print("--- \(dd.ddMMyyyy) is " + (dd.isToday ? "" : "not") + "today")
        dd.increment(by: .day)
        XCTAssertFalse(dd.isToday)
        dd.increment(by: .day, times: -1)
        XCTAssertTrue(dd.isToday)
        dd.nextMonth()
        print("--- \(dd.ddMMyyyy) is " + (dd.isToday ? "" : "not ") + "today")

        print("--- date: \(dd.ddMMyyyy)  \(dd.HHmmss) ")
        print("--- date.wholeHour: \(dd.wholeHour!.ddMMyyyy)  \(dd.wholeHour!.HHmmss) ")
    }

    func test_WholeComponent() {
        let date1Comp = DateComponents(timeZone: TimeZone.current, year: 2020, month: 9, day: 29, hour: 14, minute: 34, second: 59, nanosecond: 123_456_789)
        let date1 = Calendar.current.date(from: date1Comp)!
        XCTAssertEqual(date1.ddMMyyyy_HHmmss, "29.09.2020 14:34:59")
        XCTAssertEqual(date1.whole(.second)!.ddMMyyyy_HHmmss, "29.09.2020 14:34:59")
        XCTAssertEqual(date1.whole(.minute)!.ddMMyyyy_HHmmss, "29.09.2020 14:34:00")
        XCTAssertEqual(date1.whole(.hour)!.ddMMyyyy_HHmmss, "29.09.2020 14:00:00")
        XCTAssertEqual(date1.whole(.day)!.ddMMyyyy_HHmmss, "29.09.2020 00:00:00")
        XCTAssertEqual(date1.whole(.month)!.ddMMyyyy_HHmmss, "01.09.2020 00:00:00")
        XCTAssertEqual(date1.whole(.year)!.ddMMyyyy_HHmmss, "01.01.2020 00:00:00")

        XCTAssertEqual(date1.wholeHour!.ddMMyyyy_HHmmss, "29.09.2020 14:00:00")
        XCTAssertEqual(date1.wholeDay!.ddMMyyyy_HHmmss, "29.09.2020 00:00:00")
        XCTAssertEqual(date1.wholeMonth!.ddMMyyyy_HHmmss, "01.09.2020 00:00:00")

        // test the added format
        XCTAssertEqual(date1.ddMMyyyy_HHmm, "29.09.2020 14:34")
    }

    func test_MoreExtendedDateModsAndProps() {
        /**
         print("--- DateFormatter().timeZone: \(String(describing: DateFormatter().timeZone))")
         // --- DateFormatter().timeZone: Optional(Europe/Zurich (current))
         print("--- DateComponents().timeZone: \(String(describing: DateComponents().timeZone))")
         // --- DateComponents().timeZone: nil

         Getting Time Zone Information
         var identifier: String - The geopolitical region identifier that identifies the time zone.
         func abbreviation(for: Date) -> String? - Returns the abbreviation for the time zone at a given date.
         func secondsFromGMT(for: Date) -> Int - The current difference in seconds between the time zone and Greenwich Mean Time.

         XCTAssertEqual(timezone, TimeZone.current) // ("Europe/Zurich (fixed)") is not equal to ("GMT (current)")
         XCTAssertEqual(timezone.identifier, TimeZone.current.identifier) // ("Europe/Zurich") is not equal to ("GMT")
         XCTAssertEqual(timezone.abbreviation(), TimeZone.current.abbreviation()) // ("Optional("GMT+2")") is not equal to ("Optional("GMT")")
         XCTAssertEqual(timezone.secondsFromGMT(), TimeZone.current.secondsFromGMT()) // ("7200") is not equal to ("0")

         Notes:
         struct Date
         A Date value encapsulate a single point in time, independent of any particular calendrical system or time zone. Date values represent a time interval relative to an absolute reference date.

         class DateFormatter : Formatter
         Instances of DateFormatter create string representations of NSDate objects, and convert textual representations of dates and times into NSDate objects.

         struct DateComponents
         DateComponents encapsulates the components of a date in an extendable, structured manner.

         It is used to specify a date by providing the temporal components that make up a date and time in a particular calendar: hour, minutes, seconds, day, month, year, and so on. It can also be used to specify a duration of time, for example, 5 hours and 16 minutes. A DateComponents is not required to define all the component fields.

         DateFormatter and DateComponents both have a .timeZone: TimeZone property.

         As long as we use the same timezone for both DateFormatter and DateComponents, we get consistent results.
         This holds also if we use the TimeZone.current.
         */

        // create date1 from components, decompose and compare
        let d0Comp = DateComponents(timeZone: TimeZone.current, year: 2019, month: 7, day: 26, hour: 10, minute: 20, second: 30)
        let d0 = Calendar.current.date(from: d0Comp)!

        var d1 = d0
        XCTAssertEqual([d1.EEEE_ddMMyyyy_HHmmss, String(d1.day), String(d1.day_0)], ["Friday 26.07.2019 10:20:30", "26", "25"])

        d1.set(day: 26)
        XCTAssertEqual([d1.EEEE_ddMMyyyy_HHmmss, String(d1.day), String(d1.day_0)], ["Friday 26.07.2019 10:00:00", "26", "25"])

        d1.set(day: 25)
        XCTAssertEqual([d1.EEEE_ddMMyyyy_HHmmss, String(d1.day), String(d1.day_0)], ["Thursday 25.07.2019 10:00:00", "25", "24"])

        d1.set(day: 18)
        XCTAssertEqual([d1.EEEE_ddMMyyyy_HHmmss, String(d1.day), String(d1.day_0)], ["Thursday 18.07.2019 10:00:00", "18", "17"])

        d1.set(day: 1)
        XCTAssertEqual([d1.EEEE_ddMMyyyy_HHmmss, String(d1.day), String(d1.day_0)], ["Monday 01.07.2019 10:00:00", "1", "0"])

        d1.set(hour: 2)
        XCTAssertEqual([d1.EEEE_ddMMyyyy_HHmmss, String(d1.day), String(d1.day_0)], ["Monday 01.07.2019 02:00:00", "1", "0"])

        d1.set(hour: 8)
        XCTAssertEqual([d1.EEEE_ddMMyyyy_HHmmss, String(d1.day), String(d1.day_0)], ["Monday 01.07.2019 08:00:00", "1", "0"])

        d1.set(hour: 16)
        XCTAssertEqual([d1.EEEE_ddMMyyyy_HHmmss, String(d1.day), String(d1.day_0)], ["Monday 01.07.2019 16:00:00", "1", "0"])

        let d2Comp = DateComponents(timeZone: TimeZone.current, year: 2019, month: 9, day: 14, hour: 16, minute: 49, second: 31)
        var d2 = Calendar.current.date(from: d2Comp)!
        XCTAssertEqual(d2.EEEE_ddMMyyyy_HHmmss, "Saturday 14.09.2019 16:49:31")

        let d3 = d2.setting(hour: 9)
        XCTAssertEqual(d3!.EEEE_ddMMyyyy_HHmmss, "Saturday 14.09.2019 09:00:00")

        var d4 = d2
        d4.set(hour: 13) // sets .minute and .second to 0
        XCTAssertEqual(d4.EEEE_ddMMyyyy_HHmmss, "Saturday 14.09.2019 13:00:00")

        d4.set(day: 15) // preserves the hour
        XCTAssertEqual(d4.EEEE_ddMMyyyy_HHmmss, "Sunday 15.09.2019 13:00:00")

        d2.set(day: 22) // preserves the hour, but sets .minute and .second to 0
        XCTAssertEqual(d2.EEEE_ddMMyyyy_HHmmss, "Sunday 22.09.2019 16:00:00")

        XCTAssertEqual(d0.EEEE_ddMMyyyy_HHmmss, "Friday 26.07.2019 10:20:30")

        XCTAssertEqual(d0.year, 2019)
        XCTAssertEqual(d0.month, 7)
        XCTAssertEqual(d0.day, 26)
        XCTAssertEqual(d0.hour, 10)

        XCTAssertEqual(d0.EEEE_ddMMyyyy_HHmmss, "Friday 26.07.2019 10:20:30")
        XCTAssertEqual(d0.wholeMonth!.EEEE_ddMMyyyy_HHmmss, "Monday 01.07.2019 00:00:00")
        XCTAssertEqual(d0.wholeDay!.EEEE_ddMMyyyy_HHmmss, "Friday 26.07.2019 00:00:00")
        XCTAssertEqual(d0.wholeHour!.EEEE_ddMMyyyy_HHmmss, "Friday 26.07.2019 10:00:00")

        XCTAssertEqual(d0.dateInterval(of: .year)!.start.ddMMyyyy_HHmmss, "01.01.2019 00:00:00")
        XCTAssertEqual(d0.dateInterval(of: .year)!.end.ddMMyyyy_HHmmss, "01.01.2020 00:00:00")

        XCTAssertEqual(d0.dateInterval(of: .month)!.start.ddMMyyyy_HHmmss, "01.07.2019 00:00:00")
        XCTAssertEqual(d0.dateInterval(of: .month)!.end.ddMMyyyy_HHmmss, "01.08.2019 00:00:00")

        XCTAssertEqual(d0.dateInterval(of: .day)!.start.ddMMyyyy_HHmmss, "26.07.2019 00:00:00")
        XCTAssertEqual(d0.dateInterval(of: .day)!.end.ddMMyyyy_HHmmss, "27.07.2019 00:00:00")

        XCTAssertEqual(d0.dateInterval(of: .hour)!.start.ddMMyyyy_HHmmss, "26.07.2019 10:00:00")
        XCTAssertEqual(d0.dateInterval(of: .hour)!.end.ddMMyyyy_HHmmss, "26.07.2019 11:00:00")
    }

    func test_UsingPropertyWrappers() {
        struct UsingPropertyWrappers {
            @WholeMonth var yMonth: Date
            @WholeDay var ymDay: Date
            @WholeHour var ymdHour: Date
            @WholeHours var ymdHours: [Date]

            init(date: Date) {
                yMonth = date
                ymdHour = date
                ymDay = date
                ymdHours = []
            }
        }

        // create date1 from components, decompose and compare
        let date1Comp = DateComponents(timeZone: TimeZone.current, year: 2019, month: 7, day: 26, hour: 10, minute: 15, second: 20)
        let date1 = Calendar.current.date(from: date1Comp)!

        var iuTest = UsingPropertyWrappers(date: date1)

        XCTAssertEqual(iuTest.ymdHour.ddMMyyyy_HHmmss, "26.07.2019 10:00:00")
        XCTAssertEqual(iuTest.ymDay.ddMMyyyy_HHmmss, "26.07.2019 00:00:00")
        XCTAssertEqual(iuTest.yMonth.ddMMyyyy_HHmmss, "01.07.2019 00:00:00")
        XCTAssertEqual(iuTest.ymdHours, [])
        XCTAssertEqual(iuTest.ymdHours.map({ $0.ddMMyyyy_HHmmss }).joined(separator: " "), "")

        iuTest.ymdHour.increment(by: .hour, times: 37)
        iuTest.ymDay.increment(by: .day, times: 35)
        iuTest.yMonth.increment(by: .month, times: 33)

        XCTAssertEqual(iuTest.ymdHour.ddMMyyyy_HHmmss, "27.07.2019 23:00:00")
        XCTAssertEqual(iuTest.ymDay.ddMMyyyy_HHmmss, "30.08.2019 00:00:00")
        XCTAssertEqual(iuTest.yMonth.ddMMyyyy_HHmmss, "01.04.2022 00:00:00")

        // test ymdHours array operations

        iuTest.ymdHours.append(date1)
        XCTAssertEqual(iuTest.ymdHours, [date1.wholeHour])
        XCTAssertEqual(iuTest.ymdHours.map({ $0.ddMMyyyy_HHmmss }).joined(separator: ", "), "26.07.2019 10:00:00")

        iuTest.ymdHours.append(date1.incremented(by: .hour))
        iuTest.ymdHours.append(date1.incremented(by: .hour, times: -3))
        XCTAssertEqual(iuTest.ymdHours.map({ $0.ddMMyyyy_HHmmss }).joined(separator: ", "), "26.07.2019 10:00:00, 26.07.2019 11:00:00, 26.07.2019 07:00:00")

        iuTest.ymdHours.removeAll()
        XCTAssertEqual(iuTest.ymdHours, [])

        func demo_usingPropertyWrappers(_ date: Date) {
            @WholeHour var ymdHour = date
            @WholeHours var ymdHours = [date, date.addingTimeInterval(100_000)]
            @WholeDay var ymDay = date
            @WholeMonth var yMonth = date

            print("date:", date.EEEE_ddMMyyyy_HHmmss)
            print("ymdHour:", ymdHour.EEEE_ddMMyyyy_HHmmss)
            print("ymdHours:", ymdHours.map { $0.EEEE_ddMMyyyy_HHmmss })
            print("ymDay:", ymDay.EEEE_ddMMyyyy_HHmmss)
            print("yMonth:", yMonth.EEEE_ddMMyyyy_HHmmss)
        }

        let date = Date(timeIntervalSinceReferenceDate: 600_000_083)
        demo_usingPropertyWrappers(date)
    }

    func test_twoYearInterval() {
        // create a test Date
        let testDate = Date(timeIntervalSinceReferenceDate: 625_329_725.286_747)

        let twoYearInterval = testDate.twoYearsAround
        XCTAssertEqual(twoYearInterval.durationHours, (365 + 366) * 24)
    }

    @available(*, deprecated) // silence warnings re MMMM_yyyy
    func test_formatted_with_locale() {
        // set an arbitrary date
        let testDate = Date(timeIntervalSince1970: -1_006_344_000)
        let secondsFromUTC = TimeZone.current.secondsFromGMT(for: testDate)
        // get the corresponding date-time in UTC
        // so that the following tests become independent of the current time zone where tests are executed
        let testDateUTC = testDate.addingTimeInterval(-TimeInterval(secondsFromUTC))

        // MARK: test formats involving month names

        do {
            // <month> <year>

            XCTAssertEqual("February 1938", testDateUTC.MMMM_yyyy)

            // in slavonic languages, "MMMM" produces the genitive form of the month names
            // which is NOT SUITABLE for the <month> <year> forms
            XCTAssertEqual("veljače 1938", testDateUTC.formatted(fmt: "MMMM yyyy", locale: Locale(identifier: "hr_HR")))
            XCTAssertEqual("lutego 1938", testDateUTC.formatted(fmt: "MMMM yyyy", locale: Locale(identifier: "pl_PL")))
            XCTAssertEqual("февраля 1938", testDateUTC.formatted(fmt: "MMMM yyyy", locale: Locale(identifier: "ru_RU")))
            XCTAssertEqual("February 1938", testDateUTC.formatted(fmt: "MMMM yyyy", locale: Locale(identifier: "en_US")))
            XCTAssertEqual("février 1938", testDateUTC.formatted(fmt: "MMMM yyyy", locale: Locale(identifier: "fr_CH")))
        }
        do {
            // <day> <month> <year>

            XCTAssertEqual("10 February 1938", testDateUTC.dd_MMMM_yyyy)

            // in slavonic languages, "MMMM" produces the genitive form of the month names
            // the genitive form is SUITABLE for full dates <day> <month> <year>
            XCTAssertEqual("10 veljače 1938", testDateUTC.formatted(fmt: "dd MMMM yyyy", locale: Locale(identifier: "hr_HR")))
            XCTAssertEqual("10 lutego 1938", testDateUTC.formatted(fmt: "dd MMMM yyyy", locale: Locale(identifier: "pl_PL")))
            XCTAssertEqual("10 февраля 1938", testDateUTC.formatted(fmt: "dd MMMM yyyy", locale: Locale(identifier: "ru_RU")))
            XCTAssertEqual("10 February 1938", testDateUTC.formatted(fmt: "dd MMMM yyyy", locale: Locale(identifier: "en_US")))
            XCTAssertEqual("10 février 1938", testDateUTC.formatted(fmt: "dd MMMM yyyy", locale: Locale(identifier: "fr_CH")))
        }
        do {
            // <month> <year>

            XCTAssertEqual("February 1938", testDateUTC.LLLL_yyyy)

            // the nominative form of the month names is obtained with "LLLL"
            // this is suitable for the form <month> <year>
            XCTAssertEqual("veljača 1938", testDateUTC.formatted(fmt: "LLLL yyyy", locale: Locale(identifier: "hr_HR")))
            XCTAssertEqual("luty 1938", testDateUTC.formatted(fmt: "LLLL yyyy", locale: Locale(identifier: "pl_PL")))
            XCTAssertEqual("февраль 1938", testDateUTC.formatted(fmt: "LLLL yyyy", locale: Locale(identifier: "ru_RU")))
            XCTAssertEqual("February 1938", testDateUTC.formatted(fmt: "LLLL yyyy", locale: Locale(identifier: "en_US")))
            XCTAssertEqual("février 1938", testDateUTC.formatted(fmt: "LLLL yyyy", locale: Locale(identifier: "fr_CH")))
        }
    }

    func test_DataToFromString() {
        do {
            let string = "qwertzuiop"
            let data = Data(from: string)
            let string2 = data?.string
            XCTAssertEqual(string, string2)
            XCTAssertEqual(data?.count, 10)
        }
        do {
            let string = ""
            let data = Data(from: string)
            let string2 = data?.string
            XCTAssertEqual(string, string2)
            XCTAssertEqual(data?.count, 0)
        }
    }

    func test_WriteReadCacheFile() {
        do {
            let string = "qwertzuiop"
            let data = Data(from: string)
            guard let url = data?.writeToCacheFile(name: "zap" + string, ext: "txt") else {
                XCTFail("url == nil")
                return
            }
            guard let data2 = Data(fromFileAt: url) else {
                XCTFail("url == nil")
                return
            }
            let string2 = data2.string
            XCTAssertEqual(string, string2)
        }
        do {
            let string = ""
            let data = Data(from: string)
            guard let url = data?.writeToCacheFile(name: "zap" + string, ext: "txt") else {
                XCTFail("url == nil")
                return
            }
            guard let data2 = Data(fromFileAt: url) else {
                XCTFail("url == nil")
                return
            }
            let string2 = data2.string
            XCTAssertEqual(string, string2)
        }
    }
}
