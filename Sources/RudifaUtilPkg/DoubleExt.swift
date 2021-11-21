//
//  DoubleExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 20.11.21.
//  Copyright © 2021 Rudolf Farkas. All rights reserved.
//

import Foundation

public extension Double {
    /// Returns double formatted with 2 decimal digits
    var fmt02: String {
        String(format: "%0.2f", self)
    }

    /// Returns double formatted with 8 decimal digits
    var fmt08: String {
        String(format: "%0.8f", self)
    }
}
