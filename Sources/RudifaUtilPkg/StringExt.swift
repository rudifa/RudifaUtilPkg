//
//  StringExt.swift v.0.3.0
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 22.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import Foundation

extension String {
    /// Returns a copy of self with 1st letter capitalized
    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    /// Capitalizes 1st letter
    public mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }

    /// Capitalizes 1st letter and inserts a space before any other capital letter
    public var camelCaseSplit: String {
        var newString: String = prefix(1).capitalized
        for char in dropFirst() {
            if "A" ... "Z" ~= char, newString != "" {
                newString.append(" ")
            }
            newString.append(char)
        }
        return newString
    }
}

extension String {
    /// Localizes a text string
    /// - Parameters:
    ///   - _: bundle
    ///   - tableName: table
    /// - Returns: localized version of self (if self found in localization tables as a key)
    public func localized(bundle _: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
