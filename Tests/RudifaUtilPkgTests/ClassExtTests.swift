//
//  ClassExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 29.09.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

import XCTest

class ClassExtTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    /// ClassNameProtocol adds a class property and an instance property .className
    func test_ClassNameProtocol() {
        class MyClass: NSObject {}

        #if os(iOS)
            XCTAssertEqual("MyClass", MyClass.className)
            XCTAssertEqual("MyClass", MyClass().className)
            XCTAssertEqual("UIViewController", UIViewController.className)
            XCTAssertEqual("UIViewController", UIViewController().className)
        #endif
    }
}
