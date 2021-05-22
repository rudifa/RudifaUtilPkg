//
//  CollectionExt.swift v.0.2.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 24.12.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    /// Return array containing elements of self that are also in other, plus elements from other that are not in self
    /// - Parameter other: the array to update from
    func updatedPreservingOrder(from other: Array) -> [Element] {
        var updated: [Element] = filter { other.contains($0) }
        updated += other.filter { !self.contains($0) }
        return updated
    }

    /// Return array containing elements of self that are also in other, plus elements from other that are not in self
    /// - Parameters:
    ///   - other: the array to update from
    ///   - predicate: returns true if a pair of elements, one from each array, satisfies it
    /// - Returns: updated array
    func updatedPreservingOrder(from other: Array, predicate: (Element, Element) -> Bool) -> [Element] {
        var updated: [Element] = filter { elt1 in other.contains { (elt2) -> Bool in predicate(elt1, elt2) } }
        updated += other.filter { elt1 in !self.contains { (elt2) -> Bool in predicate(elt1, elt2) } }
        return updated
    }
}
