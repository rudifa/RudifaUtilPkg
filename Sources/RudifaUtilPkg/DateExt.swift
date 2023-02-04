//
//  DateExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 18.06.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import Foundation

// MARK: convenience properties and inits

public extension Date {
    /// Returns self as milliseconds since 1970
    var millisecondsSince1970: Int {
        Int((timeIntervalSince1970 * 1000.0).rounded())
    }

    /// Initializes a date from milliseconds since 1970
    init(millisecondsSince1970: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(millisecondsSince1970) / 1000)
    }
}

// MARK: - Extended Date Formats

public extension Date {
    /// Formats the self per format string, using TimeZone.current
    /// - Parameter fmt: a valid DateFormatter format string
    /// - Returns: date+time string

    /// Format the self per format string, using TimeZone.current
    /// - Parameters:
    ///   - fmt: a valid DateFormatter format string
    ///   - locale: a valid locale identifier (defaults to current locale)
    /// - Returns: date+time string
    func formatted(fmt: String, locale: Locale? = nil) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current // the default is UTC
        if let locale = locale {
            formatter.locale = locale // the default is system locale
        }
        formatter.dateFormat = fmt
        return formatter.string(from: self)
    }

    // MARK: computed properties, return local date strings

    /// Returns the local date string like "May 2019"
    /// Deprecated,
    /// because in slavonic languages it uses the month name in the genitive case
    /// e.g. hr: "veljače 2022", pl: "lutego 2022", ru: "февраля 2022"
    /// however, in this situation the nominative case would be appropriate
    @available(*, deprecated, message: "use LLLL_yyyy instead")
    var MMMM_yyyy: String {
        return formatted(fmt: "MMMM yyyy")
    }

    /// Returns the local date string like "February 2022"
    /// In slavonic languages, uses the month name in the nominative case
    /// as appropriate in this situation
    /// e.g. hr: "veljača 2022", pl: "luty 2022", ru: "февраль 2022"
    var LLLL_yyyy: String {
        return formatted(fmt: "LLLL yyyy")
    }

    /// Returns the local date string like "10 February 2022"
    /// In slavonic languages, uses the month name in the genitive case
    /// e.g. hr: "10 veljače 2022", pl: "10 lutego 2022", ru: "10 февраля 2022"
    /// as appropriate in this situation
    var dd_MMMM_yyyy: String {
        return formatted(fmt: "dd MMMM yyyy")
    }

    /// Returns the local date string like "18.08.2019"
    var ddMMyyyy: String {
        return formatted(fmt: "dd.MM.yyyy")
    }

    /// Returns the local date string including day, like "Sunday 18.08.2019"
    var EEEEddMMyyyy: String {
        return formatted(fmt: "EEEE dd.MM.yyyy")
    }

    /// Returns the local time string like "20:44:23"
    var HHmmss: String {
        return formatted(fmt: "HH:mm:ss")
    }

    /// Returns the local time string like "20:44"
    var HHmm: String {
        return formatted(fmt: "HH:mm")
    }

    /// Returns the local time string with milliseconds, like "12:00:00.000"
    var HHmmssSSS: String {
        return formatted(fmt: "HH:mm:ss.SSS")
    }

    /// Returns a dateTimeString with microsecond resolution, like "2020-10-25 15:42:05.286747"
    var ddMMyyyy_HHmmss_𝜇s: String {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond],
                                       from: self)
        let microSeconds = lrint(Double(comps.nanosecond!) / 1000) // Divide by 1000 and round

        let formatted = String(format: "%04ld-%02ld-%02ld %02ld:%02ld:%02ld.%06ld",
                               comps.year!, comps.month!, comps.day!,
                               comps.hour!, comps.minute!, comps.second!,
                               microSeconds)
        return formatted
    }

    /// Returns the ISO8601 string representation of self (UTC timezone)
    var iso8601UTC: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }

    /// Returns the ISO8601 string representation of self (local timezone)
    var iso8601Local: String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        return formatter.string(from: self)
    }

    /// Initializes self to the date at the specified secondsInto21stCentury
    /// - Parameter secondsInto21stCentury: seconds since 00:00:00 UTC on 1 January 2001
    init(seconds secondsInto21stCentury: TimeInterval) {
        self.init(timeIntervalSinceReferenceDate: secondsInto21stCentury)
    }

    /// Initializes self to the date specified in the ISO8601 string
    /// - Parameter fromISO8601String:like "2018-04-20T14:20:00-07:00"
    init?(iso8601String: String) {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: iso8601String) else {
            return nil
        }
        self = date
    }

    /// Initializes self to the date specified in the ISO8601 string
    /// - Parameter fromISO8601String:like "2018-04-20T14:20:00-07:00"
    init?(iso8601UTC: String) {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: iso8601UTC) else {
            return nil
        }
        self = date
    }

    /// Initializes self to the date specified in the ISO8601 string
    /// - Parameter fromISO8601String:like "2018-04-20T14:20:00-07:00"
    init?(iso8601Local: String) {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        guard let date = formatter.date(from: iso8601Local) else {
            return nil
        }
        self = date
    }

    /// Returns the detailed local date-time string, like "24.07.2019 10:00:00"
    var ddMMyyyy_HHmmss: String {
        return formatted(fmt: "dd.MM.yyyy HH:mm:ss")
    }

    /// Returns the detailed local date-time string, like "24.07.2019 10:25"
    var ddMMyyyy_HHmm: String {
        return formatted(fmt: "dd.MM.yyyy HH:mm")
    }

    /// Returns the detailed local date-time string, like "Wednesday 24.07.2019 10:00:00"
    var EEEE_ddMMyyyy_HHmmss: String {
        return formatted(fmt: "EEEE dd.MM.yyyy HH:mm:ss")
    }

    /// Returns the detailed local date-time string, like "Wednesday 24.07.2019 10:00"
    var EEEE_ddMMyyyy_HHmm: String {
        return formatted(fmt: "EEEE dd.MM.yyyy HH:mm")
    }

    /// Returns the detailed local date-time string, like "Wednesday 24.07.2019 10:00:00 +02:00"
    var EEEE_ddMMyyyy_HHmmss_ZZZZZ: String {
        return formatted(fmt: "EEEE dd.MM.yyyy HH:mm:ss ZZZZZ")
    }

    /// Returns a timestamp (timeIntervalSince1970)
    var timeStamp: TimeInterval { return timeIntervalSince1970 }

    /// Returns a timestamp string (timeIntervalSince1970), like "1566153863_69661"
    var timeTag: String {
        return String(format: "%10.5f", timeStamp).replacingOccurrences(of: ".", with: "_")
    }
}

// MARK: - Extended Date Modifiers and Properties using Calendar and DateComponents

public extension Date {
    // MARK: - modifiers

    /// Increments self by component and value
    ///
    /// - Parameters:
    ///   - component: a Calendar.Component like .hour, .day, .month, ...
    ///   - value: number of compoents (hous, days, months, ...)
    mutating func increment(by component: Calendar.Component, times value: Int = 1) {
        self = Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    /// Date incremented by component and value
    func incremented(by component: Calendar.Component, times value: Int = 1) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    /// Increments self by 1 month
    mutating func nextMonth() {
        increment(by: .month, times: 1)
    }

    /// Decrements self by 1 month
    mutating func prevMonth() {
        increment(by: .month, times: -1)
    }

    /// Returns a date with the day of month modified
    ///
    /// Preserves the .hour, sets .minute and smaller components to 0
    ///
    /// - Parameter day: day of month (1...) to set to
    /// - Returns: modified copy of self or nil if invalid date would be generated
    func setting(day: Int) -> Date? {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self)
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)
    }

    /// Modifies self, setting the day of month
    ///
    /// Preserves the .hour, sets .minute and smaller components to 0
    ///
    /// - Parameter day: day of month (1...) to set to
    mutating func set(day: Int) {
        if let date = setting(day: day) { self = date }
        else { print("*** set day failed") }
    }

    /// Returns a date with the hour modified
    ///
    /// Sets .minute and smaller components to 0
    ///
    /// - Parameter hour: hour to set to (0...23)
    /// - Returns: modified copy of self or nil if invalid date would be generated
    func setting(hour: Int) -> Date? {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self)
        dateComponents.hour = hour
        return Calendar.current.date(from: dateComponents)
    }

    /// Modifies self, setting the hour
    ///
    /// Sets .minute and smaller components to 0
    ///
    /// - Parameter hour: hour to set to (0...23)
    mutating func set(hour: Int) {
        if let date = setting(hour: hour) { self = date }
        else { print("*** set hour failed") }
    }

    /// Returns a date where components smaller than `calendarComponent` are set to 0
    ///
    /// Example
    /// let date = Date().whole(.hour) returns the date at the start of current hour
    /// - Parameters:
    ///   - calendarComponent: one of [.year, .month, .day, .hour, .minute, .second]
    /// - Returns: modified date
    func whole(_ calendarComponent: Calendar.Component) -> Date? {
        let components: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
        guard let idx = components.firstIndex(of: calendarComponent) else { return nil }
        let remaining = components[...idx]
        let dateComponents = Calendar.current.dateComponents(Set(remaining), from: self)
        return Calendar.current.date(from: dateComponents)
    }

    /// Returns a date setting the minute, second all to 0
    ///
    /// - Returns: modified copy of self or nil if invalid date would be generated
    var wholeHour: Date? {
        return whole(.hour)
    }

    /// Returns a date setting the hour, minute, second all to 0
    ///
    /// - Returns: modified copy of self or nil if invalid date would be generated
    var wholeDay: Date? {
        return whole(.day)
    }

    /// Returns a date setting the day to 1, hour, minute, second all to 0
    ///
    /// - Returns: modified copy of self or nil if invalid date would be generated
    var wholeMonth: Date? {
        return whole(.month)
    }

    // MARK: - properties

    /// Returns month (1..12)
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    /// Returns month (0..11)
    var month_0: Int {
        return month - 1
    }

    /// Returns the start date of the month
    var month1st: Date {
        return Calendar.current.dateInterval(of: .month, for: self)!.start
    }

    /// Returns the last date of the month
    var monthLast: Date {
        let then = Calendar.current.dateInterval(of: .month, for: self)!.end // in fact, start of next month
        return then.incremented(by: .day, times: -1)
    }

    /// Returns an array of days. ex. [1, 2, ..., 31]
    var daysInMonth: [Int] {
        return (Calendar.current.range(of: .day, in: .month, for: self)!).map({ $0 })
    }

    /// Returns year
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    /// Returns day in month (1...)
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    /// Returns day in month (0...)
    var day_0: Int {
        return day - 1
    }

    /// Returns weekdayOrdinal (range 1...5, 1 for 1st 7 days of the month, 2 for next 7 days, etc)
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: self)
    }

    /// Returns weekday (1...7, 1 is Sunday)
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    /// Returns weekday (0...6, 0 is Monday) of the first day of the month
    var weekday_0M: Int {
        return (weekday - 2 + 7) % 7
    }

    /// Returns weekday (1...7, 1 is Sunday) of the first day of the month
    var month1stWeekday: Int {
        return month1st.weekday
    }

    /// Returns weekday (0...6, 0 is Monday) of the first day of the month
    var month1stWeekday_0M: Int {
        return month1st.weekday_0M
    }

    /// Returns true if self is today (any hour)
    var isToday: Bool {
        let dateNow = Date()
        return day == dateNow.day && month == dateNow.month && year == dateNow.year
    }

    /// Returns hour (0..23)
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    /// Returns the date interval of `component` duration which contains self
    /// - Parameter component: calendar component
    func dateInterval(of component: Calendar.Component) -> DateInterval? {
        return Calendar.current.dateInterval(of: component, for: self)
    }

    /// Return the date interval of 2 years around self
    /// - Parameter component: calendar component
    var twoYearsAround: DateInterval {
        let end = incremented(by: .year, times: 1)
        let start = incremented(by: .year, times: -1)
        return DateInterval(start: start, end: end)
    }
}

// MARK: - Extended Calendar properties

public extension Calendar {
    /// Returns array of weekday names, starting with Monday
    var weekdaySymbols_M0: [String] {
        var wkds = weekdaySymbols
        wkds.append(wkds.first!)
        return Array(wkds.dropFirst())
    }
}

// MARK: - Property Wrappers: WholeMonth, WholeDay, WholeHour, WholeHours

// https://www.swiftbysundell.com/articles/property-wrappers-in-swift/

/**

 ### Wrapped Date variables which constrain their values to the start of the enclosing interval

  Usage example:

  ```
      func demo_usingPropertyWrappers(_ date: Date) {
          @WholeHour var ymdHour = date
          @WholeHours var ymdHours = [date, date.addingTimeInterval(100000)]
          @WholeDay var ymDay = date
          @WholeMonth var yMonth = date

          print("date:", date.EEEE_ddMMyyyy_HHmmss)
          print("ymdHour:", ymdHour.EEEE_ddMMyyyy_HHmmss)
          print("ymdHours:", ymdHours.map {$0.EEEE_ddMMyyyy_HHmmss})
          print("ymDay:", ymDay.EEEE_ddMMyyyy_HHmmss)
          print("yMonth:", yMonth.EEEE_ddMMyyyy_HHmmss)
      }

      let date = Date(timeIntervalSinceReferenceDate: 600000083)
      demo_usingPropertyWrappers(date)
  ```

  Printed output:

  ```
      date: Monday 06.01.2020 11:41:23
      ymdHour: Monday 06.01.2020 11:00:00
      ymdHours: ["Monday 06.01.2020 11:00:00", "Tuesday 07.01.2020 15:00:00"]
      ymDay: Monday 06.01.2020 00:00:00
      yMonth: Wednesday 01.01.2020 00:00:00

  ```
 */

@propertyWrapper public struct WholeMonth {
    public var wrappedValue: Date { didSet { wrappedValue = wrappedValue.wholeMonth! } }
    public init(wrappedValue: Date) { self.wrappedValue = wrappedValue.wholeMonth! }
}

/**
 Usage example: see **WholeMonth**
 */

@propertyWrapper public struct WholeDay {
    public var wrappedValue: Date { didSet { wrappedValue = wrappedValue.wholeDay! } }
    public init(wrappedValue: Date) { self.wrappedValue = wrappedValue.wholeDay! }
}

/**
 Usage example: see **WholeMonth**
 */

@propertyWrapper public struct WholeHour {
    public var wrappedValue: Date { didSet { wrappedValue = wrappedValue.wholeHour! } }
    public init(wrappedValue: Date) { self.wrappedValue = wrappedValue.wholeHour! }
}

/**
 Usage example: see **WholeMonth**
 */

@propertyWrapper public struct WholeHours {
    private var storage = [Date]()
    public var wrappedValue: [Date] {
        set { storage = newValue.map({ $0.wholeHour! }) }
        get { storage }
    }

    public init(wrappedValue: [Date]) { storage = wrappedValue.map({ $0.wholeHour! }) }
}
