//
//  NSAttributedStringExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 18.10.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

#if os(iOS)

import XCTest

class NSAttributedStringExtTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_NSAttributedStringExt() {
        let price = "24.99"
        let currency = "€ / day"
        do {
            let pcAttributedString = NSAttributedString(stringsWithStyle: [(price, .title3),
                                                                           (currency, .footnote)], separator: " ")
            XCTAssertEqual(pcAttributedString.string, "24.99 € / day")
            XCTAssertEqual(pcAttributedString.length, 13)
            let size = pcAttributedString.size()
            XCTAssertEqual(size.width.rounded(), CGFloat(96))
            XCTAssertEqual(size.height.rounded(), CGFloat(24))
        }
        do {
            let pcAttributedString = NSAttributedString(stringsWithStyle: [(price, .title1),
                                                                           (currency, .title3)], separator: " ")
            XCTAssertEqual(pcAttributedString.string, "24.99 € / day")
            XCTAssertEqual(pcAttributedString.length, 13)
            let size = pcAttributedString.size()
            XCTAssertEqual(size.width.rounded(), CGFloat(137))
            XCTAssertEqual(size.height.rounded(), CGFloat(33))
            print("pcAttributedString.className= \(pcAttributedString.className)")
            print("pcAttributedString= \(pcAttributedString)")
        }

        do {
            let blueString = NSAttributedString(string: "BLUE", fgColor: .blue)
            print("coloredString= \(blueString)")
            print("coloredString.className= \(blueString.className)")
        }

        do {
            let coloredString2 = NSAttributedString(stringsWithColor: [
                ("BLUE", .blue),
                ("RED", .red),
            ])
            print("coloredString2= \(coloredString2)")
            print("coloredString2.className= \(coloredString2.className)")
        }
    }
}
#endif
