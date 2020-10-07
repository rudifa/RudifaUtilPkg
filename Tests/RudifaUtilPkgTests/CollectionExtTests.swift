//
//  CollectionUtilTests.swift v.0.2.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 24.12.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import XCTest

class CollectionUtilTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func test_updatedPreservingOrder() {
        let aaa = [5, 4, 3, 2, 1]

        XCTAssertEqual(aaa.updatedPreservingOrder(from: aaa), [5, 4, 3, 2, 1])
        XCTAssertEqual(aaa.updatedPreservingOrder(from: [1, 2, 3, 4, 5]), [5, 4, 3, 2, 1])
        XCTAssertEqual(aaa.updatedPreservingOrder(from: [1, 2, 3, 4, 5, 6, 7]), [5, 4, 3, 2, 1, 6, 7])
        XCTAssertEqual(aaa.updatedPreservingOrder(from: [3, 4, 5, 6, 7]), [5, 4, 3, 6, 7])
        XCTAssertEqual(aaa.updatedPreservingOrder(from: [6, 7]), [6, 7])
    }
}
