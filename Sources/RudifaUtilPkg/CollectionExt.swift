//
//  CollectionExt.swift v.0.6.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 24.12.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    /// Return array containing elements of self that are also in other, plus elements from other that are not in self
    /// - Parameter other: the array to update from
    /// - Returns: updated array
    func updatedPreservingOrder(from other: Array) -> [Element] {
        var updated: [Element] = filter { other.contains($0) }
        updated += other.filter { !self.contains($0) }
        return updated
    }

    /// Update array in-place to contain elements of self that are also in other, plus elements from other that are not in self
    /// - Parameter other: the array to update from
    mutating func updatePreservingOrder(from other: Array) {
        self = updatedPreservingOrder(from: other)
    }
}

public extension Array {
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

    /// Update array in-place to contain elements of self that are also in other, plus elements from other that are not in self
    /// - Parameters:
    ///   - other: the array to update from
    ///   - predicate: returns true if a pair of elements, one from each array, satisfies it
    mutating func updatePreservingOrder(from other: Array, predicate: (Element, Element) -> Bool) {
        self = updatedPreservingOrder(from: other, predicate: predicate)
    }
}

public extension Array where Element: Equatable {
    /// Move the element to index, modifying self in-place
    /// - Parameters:
    ///   - element: to be moved
    ///   - index: new position of the element
    mutating func move(element: Element, to index: Index) {
        if let oldIndex = firstIndex(of: element) {
            if index >= 0, index < count {
                let element = remove(at: oldIndex)
                insert(element, at: index)
            }
        }
    }

    /// Move the element matching the predicate to index
    /// - Parameters:
    ///   - element: to be moved
    ///   - index: new position of the element
    /// - Returns: modified copy of self
    func moved(element: Element, to index: Index) -> [Element] {
        var temp = self
        temp.move(element: element, to: index)
        return temp
    }
}

public extension Array {
    /// Move the element at old index to new index, modifying self in-place
    /// - Parameters:
    ///   - old: index of the element to move
    ///   - new: new index of the element
    mutating func move(atIndex old: Index, toIndex new: Index) {
        if old != new, indices.contains(old), indices.contains(new) {
            insert(remove(at: old), at: new)
        }
    }

    /// Move the element at old index to new index
    /// - Parameters:
    ///   - old: index of the element to move
    ///   - new: new index of the element
    /// - Returns: modified copy of self
    func moved(atIndex old: Index, toIndex new: Index) -> [Element] {
        var temp = self
        temp.move(atIndex: old, toIndex: new)
        return temp
    }

    /// Move the element matching the predicate to index, modifying self in-place
    /// - Parameters:
    ///   - predicate: allows the move if true
    ///   - index: new position of the element
    mutating func move(where predicate: (Element) -> Bool, to index: Index) {
        if let oldIndex = firstIndex(where: predicate) {
            if index >= 0, index < count {
                let element = remove(at: oldIndex)
                insert(element, at: index)
            }
        }
    }

    /// Move the element matching the predicate to index
    /// - Parameters:
    ///   - predicate: allows the move if true
    ///   - index: new position of the element
    /// - Returns: modified copy of self
    func moved(where predicate: (Element) -> Bool, to index: Index) -> [Element] {
        var temp = self
        temp.move(where: predicate, to: index)
        return temp
    }
}
