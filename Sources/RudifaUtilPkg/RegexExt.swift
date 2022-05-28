//
//  RegexExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 28.04.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import Foundation

/**
 see also
 https://developer.apple.com/documentation/foundation/nsregularexpression // replace
 https://gist.github.com/watanabetoshinori/37f5bac79fc3f656f46c8711b6c78257
 https://learnappmaking.com/regular-expressions-swift-string/
 https://stackoverflow.com/questions/27880650/swift-extract-regex-matches
 https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
 https://www.hackingwithswift.com/articles/154/advanced-regular-expression-matching-with-nsregularexpression
 https://www.advancedswift.com/regex-capture-groups/
 */

// MARK: NSRegularExpression extension

public extension NSRegularExpression {
    /// Ininializes a regular expression with the given pattern.
    /// - Parameters:
    ///   - pattern: String
    ///   - options: 0 or more of
    ///                 .caseInsensitive,
    ///                 .allowCommentsAndWhitespace,
    ///                 .ignoreMetacharacters,
    ///                 .dotMatchesLineSeparators,
    ///                 .anchorsMatchLines,
    ///                 .useUnixLineSeparators,
    ///                 .useUnicodeWordBoundaries,
    convenience init(with pattern: String, options: NSRegularExpression.Options = []) {
        do {
            try self.init(pattern: pattern, options: options)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }

    /// Test whether the string matches the pattern.
    /// - Parameter string: String
    /// - Returns: true if the string matches the pattern
    func doesMatch(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }

    /// Find all matches found in the given string.
    /// - Parameter string: String
    /// - Returns: [String] where the first element is the matching string
    ///   and the following elements are the substrings that matched the capturing groups (if any)
    func findAll(in string: String) -> [String] {
        var captured: [String] = []
        let matches = matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        for i in 0 ..< matches.count {
            let match = matches[i]
            let j0 = match.numberOfRanges > 1 ? 1 : 0
            for j in j0 ..< match.numberOfRanges {
                let range = match.range(at: j)
                let rangeString = (string as NSString).substring(with: range)
                captured.append(rangeString)
            }
        }
        return captured
    }

    /// Replace parts matched by pattern by replacement in string
    /// - Parameters:
    ///   - pattern: String, pattrrn to match (may contain capture groups)
    ///   - replacement: String (may contain backreferences $1,... to captured matches)
    ///   - string: String, input
    /// - Returns: String, modified
    /// - Example
    ///    "Hello World!".replace(pattern: "Hello (.+)", replacement: "Goodbye $1") -> "Goodbye World!"
    func replace(pattern: String, replacement: String, in string: String) -> String {
        let modified = stringByReplacingMatches(in: string,
                                                options: [],
                                                range: NSRange(location: 0, length: string.count),
                                                withTemplate: replacement)
        return modified
    }
}

// MARK: extension String: general purpose regex methods

public extension String {
    /// Find all matches found in the given string.
    /// - Parameter capturePattern: String pattern containing optional capturing groups
    /// - Returns: [String] where the first element is the matching string
    ///   and the following elements are the substrings that matched the capturing groups (if any)
    func allMatches(with capturePattern: String) -> [String] {
        let captureRegex = try! NSRegularExpression(pattern: capturePattern)
        return captureRegex.findAll(in: self)
    }

    /// Returns an array of substrings in self that matched the regex pattern
    /// - Parameter regex: String pattern
    /// - Returns: [String]
    ///  Note: deprecated because it does not handle capture groups
    @available(*, deprecated, message: "use findAllMatches(with:) instead")
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    /// Test whether self matches the regex pattern
    /// - Parameter regex: String pattern
    /// - Returns: Bool, true if self matches the regex pattern
    func doesMatch(regex: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: regex)
        return regex.doesMatch(self)
    }

    /// Replace parts matched by pattern by replacement in self
    /// - Parameters:
    ///   - pattern: String, pattrrn to match (may contain capture groups)
    ///   - replacement: String (may contain backreferences $1,... to captured matches)
    /// - Returns: String, a modified copy of self
    /// - Example
    ///    "Hello World!".replace(pattern: "Hello (.+)", replacement: "Goodbye $1") -> "Goodbye World!"
    func replace(pattern: String, replacement: String) -> String {
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.replace(pattern: pattern, replacement: replacement, in: self)
    }
}

// MARK: extension String: specific case methods that use regex

public extension String {
    /// Check if self is blank (is empty or consists of whitespace characters only)
    /// - Returns: true if self is blank
    func isBlank() -> Bool {
        return allMatches(with: #"^\s*$"#) != []
    }

    /// Returns UUID (if any) found in self
    /// - Returns: String that matched the UUID pattern or nil
    /// - Example: "https://my-app/product_images%2F08D41FB1-8B2E-4F6F-977A-BFA876AEF775.png" -> "08D41FB1-8B2E-4F6F-977A-BFA876AEF775"
    func extractUUID() -> String? {
        let matches = allMatches(with: "[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}")
        return matches.first
    }

    /// Returns the first number found in self, or nil
    /// Expected self to contain at least one substring
    ///  representing an integer or a fixed point double,
    ///  possibly surrounded by non-numeric characters.
    ///  Example: "{\"USD\":57938.29}"
    func extractDouble() -> Double? {
        let pattNumber = #"([0-9]+(?:\.[0-9]+)*)"#
        let matches = allMatches(with: pattNumber)
        if let matches0 = matches.first, let number = Double(matches0) {
            return number
        }
        return nil
    }

    /// Returns a tuple of currency code and amount.
    /// Expects self to be a price string consisting of
    ///  a 3-letter currency code and an integer or decimal number,
    ///  in either order, separated by whitespace characters,
    ///  for example
    ///  "USD 349.95" or "234.50 EUR".
    ///  See https://en.wikipedia.org/wiki/ISO_4217
    func extractCurrencyAndAmount() -> (String, Double)? {
        let pattCurrency = #"([A-Z]{3})"#
        let pattWhitespace = #"\s+"#
        let pattNumber = #"([0-9]+(?:\.[0-9]+)*)"#
        var matched = allMatches(with: "\(pattCurrency)\(pattWhitespace)\(pattNumber)")
        if matched.count == 2, let amount = Double(matched[1]) {
            return (matched[0], amount)
        }
        matched = allMatches(with: "\(pattNumber)\(pattWhitespace)\(pattCurrency)")
        if matched.count == 2, let amount = Double(matched[0]) {
            return (matched[1], amount)
        }
        return nil
    }
}
