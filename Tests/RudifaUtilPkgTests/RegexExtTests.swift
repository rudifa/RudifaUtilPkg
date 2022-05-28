//
//  RegexExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 28.04.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import XCTest

class RegexExtTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    @available(*, deprecated) // silence warnings
    func test_string_matches() {
        var string = "🇩🇪€4.95"
        var matched = string.matches(for: "[0-9]")
        XCTAssertEqual(matched, ["4", "9", "5"])
        XCTAssertFalse(string.isBlank())

        string = "abra cadabra"
        matched = string.matches(for: "abra")
        XCTAssertEqual(matched, ["abra", "abra"])
        XCTAssertFalse(string.isBlank())

        let whitespacePattern = #"^\s*$"#
        string = ""
        matched = string.matches(for: whitespacePattern)
        XCTAssertEqual(matched, [""])
        XCTAssertTrue(string.isBlank())

        string = " \t  \n"
        matched = string.matches(for: whitespacePattern)
        XCTAssertEqual(matched, [" \t  \n"])
        XCTAssertTrue(string.isBlank())

        string = "xyz"
        matched = string.matches(for: whitespacePattern)
        XCTAssertEqual(matched, [])
        XCTAssertFalse(string.isBlank())
    }

    func test_regex_findAll_and_doesMatch() {
        do {
            var string = "🇩🇪€4.95"
            var regex = try! NSRegularExpression(pattern: "[0-9]")
            var matched = regex.findAll(in: string)
            XCTAssertEqual(matched, ["4", "9", "5"])
            XCTAssertTrue(regex.doesMatch(string))

            regex = try! NSRegularExpression(pattern: "€")
            matched = regex.findAll(in: string)
            XCTAssertEqual(matched, ["€"])
            XCTAssertTrue(regex.doesMatch(string))

            regex = try! NSRegularExpression(pattern: "abra")
            string = "abra cadabra"
            matched = regex.findAll(in: string)
            XCTAssertEqual(matched, ["abra", "abra"])
            XCTAssertTrue(regex.doesMatch(string))
        }
        do {
            let whitespacePattern = #"^\s*$"#
            let regex = try! NSRegularExpression(pattern: whitespacePattern)

            var string = ""
            var matched = regex.findAll(in: string)
            XCTAssertEqual(matched, [""])
            XCTAssertTrue(regex.doesMatch(string))

            string = " \t  \n"
            matched = regex.findAll(in: string)
            XCTAssertEqual(matched, [" \t  \n"])
            XCTAssertTrue(regex.doesMatch(string))

            string = "xyz"
            matched = regex.findAll(in: string)
            XCTAssertEqual(matched, [])
            XCTAssertFalse(regex.doesMatch(string))
        }
        do {
            let shareQRCodePattern = #"^\d{10}\.\d{5}$"#
            let regex = try! NSRegularExpression(pattern: shareQRCodePattern)
            let string = "1523953362.08907"
            let matched = regex.findAll(in: string)
            XCTAssertEqual(matched, ["1523953362.08907"])
            XCTAssertTrue(regex.doesMatch(string))
        }
    }

    func test_regex_replace() {
        do {
            let string = "Hello World!"
            let pattern = "Hello (.+)"
            let replacement = "Goodbye $1"
            let regex = try! NSRegularExpression(pattern: pattern)
            let modified = regex.replace(pattern: pattern, replacement: replacement, in: string)
            XCTAssertEqual(modified, "Goodbye World!")
        }
        do {
            let string = "234.50 EUR"
            let pattern = #"([0-9]+(?:\.[0-9]+)*)(\s+)(\w+)"#
            let replacement = "$3$2$1"
            let regex = try! NSRegularExpression(pattern: pattern)
            let swapped = regex.replace(pattern: pattern, replacement: replacement, in: string)
            XCTAssertEqual(swapped, "EUR 234.50")
        }
    }

    func test_string_allMatches_and_doesMatch() {
        do {
            var string = "🇩🇪€4.95"
            var matched = string.allMatches(with: "[0-9]")
            XCTAssertEqual(matched, ["4", "9", "5"])
            XCTAssertTrue(string.doesMatch(regex: "[0-9]"))
            XCTAssertTrue(string.doesMatch(regex: "€"))

            string = "abra cadabra"
            matched = string.allMatches(with: "abra")
            XCTAssertEqual(matched, ["abra", "abra"])
            XCTAssertFalse(string.isBlank())
        }
        do {
            let whitespacePattern = #"^\s*$"#
            var string = ""
            var matched = string.allMatches(with: whitespacePattern)
            XCTAssertEqual(matched, [""])
            XCTAssertTrue(string.isBlank())

            string = " \t  \n"
            matched = string.allMatches(with: whitespacePattern)
            XCTAssertEqual(matched, [" \t  \n"])
            XCTAssertTrue(string.doesMatch(regex: whitespacePattern))

            string = "xyz"
            matched = string.allMatches(with: whitespacePattern)
            XCTAssertEqual(matched, [])
            XCTAssertFalse(string.doesMatch(regex: whitespacePattern))
        }
        do {
            let shareQRCodePattern = #"^\d{10}\.\d{5}$"#
            let string = "1523953362.08907"
            let matched = string.allMatches(with: shareQRCodePattern)
            XCTAssertEqual(matched, ["1523953362.08907"])
            XCTAssertTrue(string.doesMatch(regex: shareQRCodePattern))
        }
    }

    func test_string_replace() {
        do {
            let string = "Hello World!"
            let pattern = "Hello (.+)"
            let replacement = "Goodbye $1"
            let modified = string.replace(pattern: pattern, replacement: replacement)
            XCTAssertEqual(modified, "Goodbye World!")
        }
        do {
            let string = "234.50 EUR"
            let pattern = #"([0-9]+(?:\.[0-9]+)*)(\s+)(\w+)"#
            let replacement = "$3$2$1"
            let swapped = string.replace(pattern: pattern, replacement: replacement)
            XCTAssertEqual(swapped, "EUR 234.50")
        }
    }

    func test_string_extractUUID() {
        let contains_UUID = "https://stick-scan/product_images%2F08D41FB1-8B2E-4F6F-977A-BFA876AEF775.png"
        let extracted_UUID = contains_UUID.extractUUID()
        XCTAssertEqual(extracted_UUID, "08D41FB1-8B2E-4F6F-977A-BFA876AEF775")
        XCTAssertNil("".extractUUID())
    }

    func test_string_extractDouble() {
        do {
            let containsADouble = #"{"USD":57938.29}"#
            let extracted = containsADouble.extractDouble()
            XCTAssertEqual(extracted, 57938.29)
            XCTAssertNil("".extractDouble())
        }
        do {
            let containsAnInt = #"roman IM is 999"#
            let extracted = containsAnInt.extractDouble()
            XCTAssertEqual(extracted, 999)
            XCTAssertNil("".extractDouble())
        }
    }

    func test_extractCurrencyAndAmount() {
        do {
            let price = "USD 349.95"
            let expected = ("USD", 349.95)
            let extracted = price.extractCurrencyAndAmount()
            if let extracted = extracted {
                XCTAssertEqual(expected.0, extracted.0)
                XCTAssertEqual(expected.1, extracted.1)
            } else {
                XCTFail()
            }
        }
        do {
            let price = "234.50 EUR"
            let expected = ("EUR", 234.50)
            let extracted = price.extractCurrencyAndAmount()
            if let extracted = extracted {
                XCTAssertEqual(expected.0, extracted.0)
                XCTAssertEqual(expected.1, extracted.1)
            } else {
                XCTFail()
            }
        }
        do {
            let price = "55 EUR"
            let expected = ("EUR", 55.0)
            let extracted = price.extractCurrencyAndAmount()
            if let extracted = extracted {
                XCTAssertEqual(expected.0, extracted.0)
                XCTAssertEqual(expected.1, extracted.1)
            } else {
                XCTFail()
            }
        }
    }

    func test_CaptureGroups_investigate_1() {
        let name = "firstName middleName lastName"
        let capturePattern = #"([a-zA-Z-]+) ?.* ([a-zA-Z-]+)?"#
        let captureRegex = try! NSRegularExpression(pattern: capturePattern)
        let matches = captureRegex.matches(in: name, options: [], range: NSRange(location: 0, length: name.utf16.count))

        print("#1 matches: \(matches.count), \(matches)")
        print("#1 matches[0]: \(matches[0])")
        print("#1 matches[0].range(at: 1): \(matches[0].range(at: 1))")

        XCTAssertEqual(matches.count, 1)
        let match = matches[0]
        XCTAssertEqual(match.numberOfRanges, 3)
        XCTAssertEqual(match.range(at: 0).location, 0)
        XCTAssertEqual(match.range(at: 0).length, 29)
        XCTAssertEqual(match.range(at: 1).location, 0)
        XCTAssertEqual(match.range(at: 1).length, 9)

        XCTAssertEqual(match.range(at: 2).location, 21)
        XCTAssertEqual(match.range(at: 2).length, 8)

        var names: [String] = []
        for rangeIndex in 1 ..< match.numberOfRanges {
            let range = match.range(at: rangeIndex)
            let rangeString = (name as NSString).substring(with: range)
            print("#2 Range \(rangeIndex): \(rangeString)")
            names.append(rangeString)
        }

        print("#2 matches: \(matches)")
        print("#2 names: \(names)")

        XCTAssertEqual(names, ["firstName", "lastName"])

        var names2: [String] = []
        for rangeIndex in 0 ..< match.numberOfRanges {
            let matchRange = match.range(at: rangeIndex)

            // ignore matching the entire name string
            if matchRange == NSRange(location: 0, length: name.utf16.count) {
                continue
            }

            if let substringRange = Range(matchRange, in: name) {
                let substring = name[substringRange]
                print("#3 Range \(rangeIndex): \(substring)")
                names2.append(String(substring))
            }
        }
        XCTAssertEqual(names2, ["firstName", "lastName"])
    }

    func test_CaptureGroups_investigate_2() {
        let string = "a 1 b 22 c 333 capture groups and things"
        do {
            let pattern = #"\d{1,4}"# // no capture groups
            let regex = try! NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
            print("#11 matches: count:\(matches.count), \(matches)")
        }
        do {
            let pattern = #"(\d{1,4})"# // capture groups
            let regex = try! NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
            print("#12 matches: count:\(matches.count), \(matches)")
        }
    }

    func test_CaptureGroups_investigate_3() {
        let emails = "emails: alice@rabbithole.com, bob@bobbitearth.com, charlie@chocolate.com"
        do {
            let pattern = #"\w[\w\.]+@\w[\w\.]+\w"# // non capturing
            let regex = try! NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: emails, options: [], range: NSRange(location: 0, length: emails.utf16.count))
            print("#21 matches.count:\(matches.count)")
            var counts = [[matches.count]]
            for i in 0 ..< matches.count {
                let match = matches[i]
                counts.append([match.numberOfRanges])
                for j in 0 ..< match.numberOfRanges {
                    let range = match.range(at: j)
                    let rangeString = (emails as NSString).substring(with: range)
                    print("#22 Range \(i),\(j): \(rangeString)")
                }
            }
            print("#23 counts: \(counts)")
            XCTAssertEqual(counts, [[3], [1], [1], [1]])
        }
        do {
            let pattern = #"(\w[\w\.]+)@(\w[\w\.]+\w)"# // capturing
            let regex = try! NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: emails, options: [], range: NSRange(location: 0, length: emails.utf16.count))
            print("#31 matches.count:\(matches.count)")
            var counts = [[matches.count]]
            for i in 0 ..< matches.count {
                let match = matches[i]
                counts.append([match.numberOfRanges])
                for j in 0 ..< match.numberOfRanges {
                    let range = match.range(at: j)
                    let rangeString = (emails as NSString).substring(with: range)
                    print("#32 Range \(i),\(j): \(rangeString)")
                }
            }
            print("#33 counts: \(counts)")
            XCTAssertEqual(counts, [[3], [3], [3], [3]])
        }
        do {
            let pattern = #"((\w[\w\.]+)@(\w[\w\.]+\w))"# // capturing, outermost parens are superfluous
            let regex = try! NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: emails, options: [], range: NSRange(location: 0, length: emails.utf16.count))
            print("#41 matches.count:\(matches.count)")
            var counts = [[matches.count]]
            for i in 0 ..< matches.count {
                let match = matches[i]
                counts.append([match.numberOfRanges])
                for j in 0 ..< match.numberOfRanges {
                    let range = match.range(at: j)
                    let rangeString = (emails as NSString).substring(with: range)
                    print("#42 Range \(i),\(j): \(rangeString)")
                }
            }
            print("#43 counts: \(counts)")
            XCTAssertEqual(counts, [[3], [4], [4], [4]])
        }
    }

    func test_regex_findall_and_string_findAllMatches() {
        //        /Users/rudifarkas/GitHub/python3/regex/./regex-tests.py
        //        matches = re.findall(pattern, emails)
        //        all matches: ['alice@rabbithole.com', 'bob@bobbitearth.com', 'charlie@chocolate.com']
        //        all matches: [('alice', 'rabbithole.com'), ('bob', 'bobbitearth.com'), ('charlie', 'chocolate.com')]
        //        all matches: [('alice@rabbithole.com', 'alice', 'rabbithole.com'), ('bob@bobbitearth.com', 'bob', 'bobbitearth.com'), ('charlie@chocolate.com', 'charlie', 'chocolate.com')]

        let emails = "emails: alice@rabbithole.com, bob@bobbitearth.com, charlie@chocolate.com"
        do {
            let pattern = #"\w[\w\.]+@\w[\w\.]+\w"# // non capturing
            let regex = try! NSRegularExpression(pattern: pattern)
            do {
                let matching = regex.findAll(in: emails)
                print("#21 matching count:\(matching.count), matching: \(matching)")
                XCTAssertEqual(matching, ["alice@rabbithole.com", "bob@bobbitearth.com", "charlie@chocolate.com"])
            }
            do {
                let matching = emails.allMatches(with: pattern)
                print("#21a matching count:\(matching.count), matching: \(matching)")
                XCTAssertEqual(matching, ["alice@rabbithole.com", "bob@bobbitearth.com", "charlie@chocolate.com"])
            }
        }
        do {
            let pattern = #"(\w[\w\.]+)@(\w[\w\.]+\w)"# // capturing
            let regex = try! NSRegularExpression(pattern: pattern)
            do {
                let matching = regex.findAll(in: emails)
                print("#31 matching count:\(matching.count), matching: \(matching)")
                XCTAssertEqual(matching, ["alice", "rabbithole.com", "bob", "bobbitearth.com", "charlie", "chocolate.com"])
            }
            do {
                let matching = emails.allMatches(with: pattern)
                print("#21a matching count:\(matching.count), matching: \(matching)")
                XCTAssertEqual(matching, ["alice", "rabbithole.com", "bob", "bobbitearth.com", "charlie", "chocolate.com"])
            }
        }
        do {
            let pattern = #"((\w[\w\.]+)@(\w[\w\.]+\w))"# // capturing, with outermost parens
            let regex = try! NSRegularExpression(pattern: pattern)
            do {
                let matching = regex.findAll(in: emails)
                print("#31 matching count:\(matching.count), matching: \(matching)")
                XCTAssertEqual(matching, ["alice@rabbithole.com", "alice", "rabbithole.com", "bob@bobbitearth.com", "bob", "bobbitearth.com", "charlie@chocolate.com", "charlie", "chocolate.com"])
            }
            do {
                let matching = emails.allMatches(with: pattern)
                print("#21a matching count:\(matching.count), matching: \(matching)")
                XCTAssertEqual(matching, ["alice@rabbithole.com", "alice", "rabbithole.com", "bob@bobbitearth.com", "bob", "bobbitearth.com", "charlie@chocolate.com", "charlie", "chocolate.com"])
            }
        }
    }
}
