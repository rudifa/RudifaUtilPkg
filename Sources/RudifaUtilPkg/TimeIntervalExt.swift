//
//  TimeIntervalExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 22.06.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import Foundation

// TODO: - merge into DateUtil

extension TimeInterval {
    internal static var secondsPerDay: Double { return 24 * 60 * 60 }

    public init(days: Double) {
        self = days * TimeInterval.secondsPerDay
    }
}
