//
//  FileManagerExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 05.09.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import XCTest

class FileManagerExtTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_FileManager_cacheFilePath() {
        let cacheFileUrl = FileManager.cacheFilePath(fileName: "testfile", fileExt: "txt")!

        // validate cacheFileUrl by using it in file operations

        let testString = "hello FileManager cache"
        let testData = testString.data(using: .utf8)!

        do {
            try testData.write(to: cacheFileUrl, options: [.atomicWrite])
        } catch {
            XCTFail("testData.write failed")
        }

        if let data = try? Data(contentsOf: cacheFileUrl) {
            XCTAssertEqual(data, testData)
            XCTAssertEqual(String(data: data, encoding: .utf8), testString)

        } else {
            XCTFail("testData read failed")
        }
    }
}
