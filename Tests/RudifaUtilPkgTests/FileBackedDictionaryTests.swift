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

        // remove all (from a previous test run)
        fbDict.removeAll()
        XCTAssertEqual(fbDict.count, 0)
        XCTAssertEqual(fbDict.keys, [])
        XCTAssertEqual(fbDict.fileNames, [])

        // create an array of resources
        let resource1 = Resource(name: "resource_1", value: 1, quantity: 1)
        let resource2 = Resource(name: "resource_2", value: 2, quantity: 2)
        let resource3 = Resource(name: "resource_3", value: 3, quantity: 3)
        let resources = [resource1, resource2, resource3]

        // add the resources to the dictionary from array, using the name as key
        for resource in resources {
            fbDict[resource.name] = resource
        }

        // check the filenames
        XCTAssertEqual(fbDict.fileNames, ["resource_1", "resource_2", "resource_3"])

        do {
            // can we add a resource with a filename containig "/"?
            let resource4 = Resource(name: "resource_4/slash", value: 4, quantity: 4)
            fbDict[resource4.name] = resource4
            XCTAssertEqual(fbDict.count, 3)
            XCTAssertEqual(fbDict.keys, ["resource_1", "resource_2", "resource_3"])

            // check that the resource4 fileName is MISSING
            // (because the creation of the file silently failed)
            XCTAssertEqual(fbDict.fileNames, ["resource_1", "resource_2", "resource_3"])
        }

        do {
            // can we add a resource with a filename containig a leading "."?
            let resource5 = Resource(name: ".resource_5leadingperiod", value: 5, quantity: 5)
            fbDict[resource5.name] = resource5
            XCTAssertEqual(fbDict.count, 4)
            XCTAssertEqual(fbDict.keys, [".resource_5leadingperiod", "resource_1", "resource_2", "resource_3"])

            // check that the resource5 fileName is not missing (it is a hidden file but fileNames lists these)
            // (because the creation of the file silently failed)
            XCTAssertEqual(fbDict.fileNames, [".resource_5leadingperiod", "resource_1", "resource_2", "resource_3"])
        }
    }

    func test_FileBackedDictionary3() {
        // remove the target file directory, in case it was polluted by previous tests
        FileBackedDictionary<Resource>.deleteDirectory(named: "test_directory3")

        // create a FileBackedDictionary under test with directory named
        // "test_directory" using struct Resource as the value type
        let directoryName = "test_directory3"
        var fbDict = FileBackedDictionary<Resource>(directoryName: directoryName)

        // remove all (from a previous test run)
        fbDict.removeAll()
        XCTAssertEqual(fbDict.count, 0)
        XCTAssertEqual(fbDict.keys, [])
        XCTAssertEqual(fbDict.fileNames, [])

        // can we add a resource with a name containig suspect characters?

        // Tests below show that all of 29 suspect characters are allowed in FileManager filenames
        // EXCEPT "/", which must be disallowed in FileBackedDictionary keys.

        // Create an array of resources where each name contains one of the suspect characters
        let resourcesWithSuspectNames = [
            Resource(name: "resource_11/slash", value: 11, quantity: 11),
            Resource(name: "resource_12:colon", value: 12, quantity: 12),
            Resource(name: "resource_13\\backslash", value: 13, quantity: 13),
            Resource(name: "resource_14*asterisk", value: 14, quantity: 14),
            Resource(name: "resource_15?questionmark", value: 15, quantity: 15),
            Resource(name: "resource_16<lessthan", value: 16, quantity: 16),
            Resource(name: "resource_17>greaterthan", value: 17, quantity: 17),
            Resource(name: "resource_18|pipe", value: 18, quantity: 18),
            Resource(name: "resource_19\"quote", value: 19, quantity: 19),
            Resource(name: " resource_20leadingwhitespace", value: 20, quantity: 20),
            Resource(name: "resource_21trailingwhitespace ", value: 21, quantity: 21),
            Resource(name: ".resource_22leadingperiod", value: 22, quantity: 22),
            Resource(name: "resource_23.notleadingperiod", value: 23, quantity: 23),

            // add some more punctuation characters: "@ # $ % & () [] {} = + ; , ~"

            Resource(name: "resource_24@at", value: 24, quantity: 24),
            Resource(name: "resource_25#hash", value: 25, quantity: 25),
            Resource(name: "resource_26$dollar", value: 26, quantity: 26),
            Resource(name: "resource_27%percent", value: 27, quantity: 27),
            Resource(name: "resource_28&and", value: 28, quantity: 28),
            Resource(name: "resource_29(leftparen", value: 29, quantity: 29),
            Resource(name: "resource_30)rightparen", value: 30, quantity: 30),
            Resource(name: "resource_31[leftbracket", value: 31, quantity: 31),
            Resource(name: "resource_32]rightbracket", value: 32, quantity: 32),
            Resource(name: "resource_33{leftbrace", value: 33, quantity: 33),
            Resource(name: "resource_34}rightbrace", value: 34, quantity: 34),
            Resource(name: "resource_35=equal", value: 35, quantity: 35),
            Resource(name: "resource_36+plus", value: 36, quantity: 36),
            Resource(name: "resource_37;semicolon", value: 37, quantity: 37),
            Resource(name: "resource_38,comma", value: 38, quantity: 38),
            Resource(name: "resource_39~tilde", value: 39, quantity: 39),
        ]
        // add the resources to the dictionary from array, using the name as key
        for resource in resourcesWithSuspectNames {
            fbDict[resource.name] = resource
        }

        // loop over the resources and print the index and the name
        for (index, resource) in resourcesWithSuspectNames.enumerated() {
            printClassAndFunc("index= \(index), resource.name= \"\(resource.name)\"")
        }

        // compare the numbers
        XCTAssertEqual(resourcesWithSuspectNames.count, 29)
        XCTAssertEqual(fbDict.count, 28)
        XCTAssertEqual(fbDict.fileNames.count, 28)

        // make sets of expected names, of actual fbdict.keys and the fbdict.enumFiles()
        let resourceNames = Set(resourcesWithSuspectNames.map(\.name))
        let actualDictKeys = Set(fbDict.keys)
        let actualFilenames = Set(fbDict.fileNames)

        // find the missing keys and filenames
        let missingDictKeys = resourceNames.subtracting(actualDictKeys)
        let missingFilenames = resourceNames.subtracting(actualFilenames)

        // check that the set of missing dictKeys is as expected
        let expectedMissingDictKeys: Set<String> = ["resource_11/slash"] // missing because a file creation with this name failed
        XCTAssertEqual(missingDictKeys, expectedMissingDictKeys)

        // check that the set of missing filenames is as expected
        let expectedMissingFilenames: Set<String> = ["resource_11/slash"]
        XCTAssertEqual(missingFilenames, expectedMissingFilenames)
    }
}
