//
//  OptionalExt.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 15.10.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Int {
    /// Increment an optional Int (also from nil to val)
    ///
    /// - Parameter val: to increment by
    public mutating func increment(by val: Int = 1) {
        self = (self ?? 0) + val
    }
}
