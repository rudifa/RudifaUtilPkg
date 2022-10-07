//
//  DataExt.swift
//
//
//  Created by Rudolf Farkas on 07.10.22.
//

import Foundation

public extension Data {
    /// Convert self to an Int value
    var toInt: Int {
        return withUnsafeBytes { $0.load(as: Int.self) }
    }

    /// Convert self to a binary integer value
    /// - Returns: a binary integer value
    /// - Note: annotate the return value, e.g. `var myInt: Int64 = myData.binInt()`
    func binInt<T: BinaryInteger>() -> T {
        return withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            ptr.load(as: T.self)
        }
    }
}
