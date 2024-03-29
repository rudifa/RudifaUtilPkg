//
//  EnumExt.swift
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
    letter.toNext(true)  // .b
    letter.toNext(true)  // .c
    letter.toNext(true)  // .a
    letter.toNext(true)  // .b
    letter.toNext(false)  // .a
    letter.toNext(false)  // .c
 ```
 */
public extension CaseIterable where Self: Equatable {
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

    /// Returns the next enumerated value (circularly)
    var next: Self {
        return all[(index + 1) % count]
    }

    /// Returns the previous enumerated value (circularly)
    var prev: Self {
        return all[(index + count - 1) % count]
    }

    /// Increments or decrements self (circularly)
    @available(*, deprecated, message: "use .toNext(next:) instead")
    mutating func next(_ next: Bool = true) {
        self = next ? self.next : prev
    }

    /// Increments or decrements self (circularly)
    mutating func toNext(_ next: Bool) {
        self = next ? self.next : prev
    }

    /// Increments or decrements self (circular)
    @available(*, deprecated, message: "use .toNext(next:) instead")
    mutating func increment(next: Bool) {
        self = next ? self.next : prev
    }

    /// Returns an incremented or decremented copy of self (circular)
    @available(*, deprecated, message: "use properties .next or .prev instead")
    mutating func incremented(next: Bool) -> Self {
        increment(next: next)
        return self
    }
}
