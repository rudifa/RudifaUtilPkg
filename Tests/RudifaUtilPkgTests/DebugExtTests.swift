//
//  DebugExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 23.07.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import XCTest

class DebugExtTests: XCTestCase {
    @available(*, deprecated) // silence warnings
    func test_printClassAndFunc() {
        // deprecated style
        printClassAndFunc(info: "more info")
        printClassAndFunc(info: "@ even more info at this time")
        printClassAndFunc(info: "@ even more info a tad later")

        // current style
        printClassAndFunc()
        printClassAndFunc("")
        printClassAndFunc("more info")
        printClassAndFunc("@ even more info at this time")
        printClassAndFunc("@ even more info a tad later")

        logClassAndFunc()
        logClassAndFunc("")
        logClassAndFunc("more info")
        logClassAndFunc("@ even more info at this time")
        logClassAndFunc("@ even more info a tad later")
    }
}
