//
//  NSAttributedStringExtTests.swift
//  RudifaUtilPkgDemoTests
//
//  Created by Rudolf Farkas on 18.10.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import XCTest

class NSAttributedStringExtTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_NSAttributedStringExt() {
        let price = "24.99"
        let currency = "€ / day"
        do {
            let pcAttributedString: NSAttributedString = NSAttributedString(stringsWithStyle: [(price, .title3), (currency, .footnote)], separator: " ")
            XCTAssertEqual(pcAttributedString.string, "24.99 € / day")
            XCTAssertEqual(pcAttributedString.length, 13)
            XCTAssertEqual(pcAttributedString.size(), CGSize(width: 95.9931640625, height: 23.8671875))
        }
        do {
            let pcAttributedString: NSAttributedString = NSAttributedString(stringsWithStyle: [(price, .title1), (currency, .title3)], separator: " ")
            XCTAssertEqual(pcAttributedString.string, "24.99 € / day")
            XCTAssertEqual(pcAttributedString.length, 13)
            XCTAssertEqual(pcAttributedString.size(), CGSize(width: 137.123046875, height: 33.4140625))
        }
    }
}
