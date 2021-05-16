//
//  StringRegexExt.swift v.0.6.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 28.04.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import Foundation

/**
 see also
 https://learnappmaking.com/regular-expressions-swift-string/
 https://stackoverflow.com/questions/27880650/swift-extract-regex-matches
 https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
 */

extension String {
    /// Returns an array of substrings in self that matched the regex pattern
    /// - Parameter regex: pattern
    /// - Returns: [String]
    public func matches(for regex: String) -> [String] {
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

    /// Check if self is blank (is empty or consists of whitespace characters only)
    /// - Returns: true if self is blank
    public func isBlank() -> Bool {
        return matches(for: "^\\s*$") != []
    }

    /// Returns true if self matches the regex pattern
    /// - Parameter regex: pattern
    /// - Returns: Bool
    public func doesMatch(regex: String) -> Bool {
        return matches(for: regex) != []
    }
}

extension String {
    /// Returns UUID (if any) found in self
    /// - Returns: String that matched the UUID pattern or nil
    /// - Example: "https://my-app/product_images%2F08D41FB1-8B2E-4F6F-977A-BFA876AEF775.png" -> "08D41FB1-8B2E-4F6F-977A-BFA876AEF775"
    public func extractUUID() -> String? {
        let matches = self.matches(for: "[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}")
        return matches.first
    }

    /// Return the first number found in self, or nil
    ///  self is expected to contain at least one substring
    ///  representing an integer or a fixed point double,
    ///  possibly surrounded by non-numeric characters.
    ///  Example: "{\"USD\":57938.29}"
    public func extractDouble() -> Double? {
        let matches = self.matches(for: "[0-9.]+")
        if let matches0 = matches.first, let number = Double(matches0) {
            return number
        }
        return nil
    }

}
