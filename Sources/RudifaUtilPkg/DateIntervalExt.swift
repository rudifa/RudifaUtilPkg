//
//  DateIntervalExt.swift v.0.1.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 28.08.20.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import Foundation

// MARK: - Extended DateInterval properties

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
