//
//  DateIntervalExt.swift v.0.1.3
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 28.08.20.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import Foundation

// MARK: - Extended DateInterval properties

public extension DateInterval {
    /// Returns true if self fully overlaps with interval
    /// - Parameter interval: interval to compare with
    func fullyOverlaps(with interval: DateInterval) -> Bool {
        if let intersection = self.intersection(with: interval) {
            if intersection.duration >= min(duration, interval.duration) {
                return true
            }
        }
        return false
    }

    /// Returns true if self partially overlaps with interval
    /// - Parameter interval: interval to compare with
    func partiallyOverlaps(with interval: DateInterval) -> Bool {
        if let intersection = self.intersection(with: interval) {
            if intersection.duration > 0.0 {
                return true
            }
        }
        return false
    }

    /// Return the duration in hours, truncated to the nearest lower integer
    var durationHours: Int {
        return Int(floor(duration / 3600.0))
    }

    /// Return seconds from hours
    /// - Parameter hours: whole hours to convert to seconds
    /// - Returns: seconds
    internal static func secondsFromHours(_ hours: Int) -> TimeInterval {
        return 3600.0 * Double(hours)
    }

    /// Intitialize from startDate (truncating to the whole hour) and duration
    /// - Parameters:
    ///   - startDate: start
    ///   - durationHours: hours
    init?(startDate: Date, durationHours: Int = 1) {
        guard durationHours > 0 else { return nil }
        self.init(start: startDate.wholeHour!, duration: Self.secondsFromHours(durationHours))
    }

    /// Return a two-year interval around the data
    /// - Parameter date: center of the interval
    /// - Returns: DateInterval
    static func twoYearsAround(date: Date) -> DateInterval {
        let end = date.incremented(by: .year, times: 1)
        let start = date.incremented(by: .year, times: -1)
        return DateInterval(start: start, end: end)
    }

    /// Return true if the interval is fully in the future, false otherwise
    var isInTheFuture: Bool {
        return start > Date()
    }

    var brief: String {
        "\(start.ddMMyyyy_HHmmss) to \(end.ddMMyyyy_HHmmss)"
    }
}
