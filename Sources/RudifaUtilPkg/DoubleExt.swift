//
//  DoubleExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 20.11.21.
//  Copyright © 2021 Rudolf Farkas. All rights reserved.
//

import Foundation

public extension Double {
    var fmt02: String {
        String(format: "%0.2f", self)
    }

    var fmt08: String {
        String(format: "%0.8f", self)
    }
}
