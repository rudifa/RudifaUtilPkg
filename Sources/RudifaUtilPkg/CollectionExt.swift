//
//  CollectionExt.swift v.0.2.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 24.12.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    /// Return array containing elements of self that are also in other, plus elements from other that are not in self
    /// - Parameter other: the array to update from
    public func updatedPreservingOrder(from other: Array) -> [Element] {
        var updated: [Element] = filter { other.contains($0) }
        updated += other.filter { !self.contains($0) }
        return updated
    }
}
