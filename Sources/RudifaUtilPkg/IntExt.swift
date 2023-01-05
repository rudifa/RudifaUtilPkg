//
//  IntExt.swift
//
//
//  Created by Rudolf Farkas on 05.01.23.
//  Copyright © 2023 Rudolf Farkas. All rights reserved.
//

import Foundation

public extension Int {
    /// Return the value incremented or decremented, wrapped around the range 0..<count>
    /// - Parameters:
    ///   - up:
    ///   - count:
    /// - Returns: modified falue
    /// - Remark: noop if self < 0
    private func incrementedWrapping(up: Bool, count: Int) -> Int {
        guard self >= 0, count > 0 else { return self }
        return (self + (up ? 1 : -1) + count) % count
    }

        /// Return incremented self, constrained to range 0..<count>
    /// - Parameter count:
    /// - Returns: self + 1 wrapped around on count
    func next(count: Int) -> Int {
        return incrementedWrapping(up: true, count: count)
    }

    /// Return decremented self, constrained to range 0..<count>
    /// - Parameter count:
    /// - Returns: self - 1 wrapped around on count
    func prev(count: Int) -> Int {
        return incrementedWrapping(up: false, count: count)
    }

    mutating func toNext(next: Bool, count: Int) {
        self = incrementedWrapping(up: next, count: count)
    }
}
