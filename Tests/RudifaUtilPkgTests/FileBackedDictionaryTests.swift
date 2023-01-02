//
//  FileBackedDictionaryTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 24.12.22.
//

import RudifaUtilPkg
import XCTest

class FileBackedDictionaryTests: XCTestCase {
    func test_SubscriptSetterAndGetter() {
        let directoryName = "test_directory"
        var fbd = FileBackedDictionary<String>(directoryName: directoryName)

        // fbd.removeAll()

        let expectedValue = "test_value"

        fbd["test_key"] = expectedValue

        XCTAssertEqual(fbd["test_key"], expectedValue)

        fbd["test_key_2"] = expectedValue + expectedValue

        do {
            let fbd2 = FileBackedDictionary<String>(directoryName: directoryName)
            XCTAssertEqual(fbd2.count, 2)
            printClassAndFunc("fbd2.keys= \(fbd2.keys)")
        }

        fbd["test_key_2"] = nil

        do {
            let fbd2 = FileBackedDictionary<String>(directoryName: directoryName)
            XCTAssertEqual(fbd2.count, 1)
        }
    }

    // create a struct Resource for testing
    struct Resource: Codable, Equatable {
        let name: String
        let value: Int
        let quantity: Int
    }

    func test_FileBackedDictionary1() {
        // create a FileBackedDictionary under test with directory named
        // "test_directory" using struct Resource as the value type
        let directoryName = "test_directory1"
        var fbDict = FileBackedDictionary<Resource>(directoryName: directoryName)

        let resource1 = Resource(name: "resource_1", value: 1, quantity: 1)
        let resource2 = Resource(name: "resource_2", value: 2, quantity: 2)
        let resource3 = Resource(name: "resource_3", value: 3, quantity: 3)

        fbDict["resource_1"] = resource1
        fbDict["resource_2"] = resource2
        fbDict["resource_3"] = resource3

        XCTAssertEqual(fbDict.count, 3)
        // keys
        XCTAssertEqual(fbDict.keys, ["resource_1", "resource_2", "resource_3"])
        // values
        XCTAssertEqual(fbDict.values, [resource1, resource2, resource3])

        // remove resource_2 by setting it to nil
        fbDict["resource_2"] = nil
        XCTAssertEqual(fbDict.count, 2)
        XCTAssertEqual(fbDict.keys, ["resource_1", "resource_3"])
        XCTAssertEqual(fbDict.values, [resource1, resource3])

        // remove all
        fbDict.removeAll()
        XCTAssertEqual(fbDict.count, 0)
        XCTAssertEqual(fbDict.keys, [])
        XCTAssertEqual(fbDict.values, [])
    }

    func test_FileBackedDictionary2() {
        // create a FileBackedDictionary under test with directory named
        // "test_directory" using struct Resource as the value type
        let directoryName = "test_directory2"
        var fbDict = FileBackedDictionary<Resource>(directoryName: directoryName)

        // create an array of resources
        let resource1 = Resource(name: "resource_1", value: 1, quantity: 1)
        let resource2 = Resource(name: "resource_2", value: 2, quantity: 2)
        let resource3 = Resource(name: "resource_3", value: 3, quantity: 3)
        let resources = [resource1, resource2, resource3]

        // add the resources to the dictionary from array, using the name as key
        for resource in resources {
            fbDict[resource.name] = resource
        }

        XCTAssertEqual(fbDict.count, 3)
        // keys
        XCTAssertEqual(fbDict.keys, ["resource_1", "resource_2", "resource_3"])
        // values
        XCTAssertEqual(fbDict.values, [resource1, resource2, resource3])
    }
}
