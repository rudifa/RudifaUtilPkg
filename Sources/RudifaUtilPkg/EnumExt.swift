//
//  EnumExt.swift v.0.3.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 18.03.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/51103795/how-to-get-next-case-of-enumi-e-write-a-circulating-method-in-swift-4-2
/**
 Extension adds a circular iterator to a CaseIterable item, usually an enum
 ```
    enum MyEnum: CaseIterable { case a, b, c }
    var letter = MyEnum.a
    letter = letter.next
 ```
 */
extension CaseIterable where Self: Equatable {
    /// Returns allCases as Array
    private var all: [Self] {
        return Array(Self.allCases)
    }

    /// Returns the index of self
    private var index: Int {
        return all.firstIndex(of: self)!
    }

    /// Returns the count of cases
    private var count: Int {
        return Self.allCases.count
    }

    /// Returns the next enumerated value (circular)
    public var next: Self {
        return all[(index + 1) % count]
    }

    /// Returns the previous enumerated value (circular)
    public var prev: Self {
        return all[(index + count - 1) % count]
    }

    /// Perform circular increment or decrement of self
    public mutating func increment(next: Bool) {
        self = next ? self.next : prev
    }

    /// Perform circular increment or decrement of self and return it
    public mutating func incremented(next: Bool) -> Self {
        increment(next: next)
        return self
    }
}
