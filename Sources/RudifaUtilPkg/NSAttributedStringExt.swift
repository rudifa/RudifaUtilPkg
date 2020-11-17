//
//  NSAttributedStringExt.swift
//  RudifaUtilPkgDemo
//
//  Created by Rudolf Farkas on 18.10.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import UIKit

extension NSAttributedString {
    /// Initialize from a string using the textStyle
    /// - Parameters:
    ///   - string: input string
    ///   - textStyle: input font text style
    public convenience init(string: String, textStyle: UIFont.TextStyle) {
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: textStyle)]
        self.init(string: string, attributes: attributes)
    }

    /// Initialize from an array of strings with styles, joining with the separator
    /// - Parameters:
    ///   - stringsWithStyle: array of tuples (string, style)
    ///   - separator: string
    public convenience init(stringsWithStyle: [(String, UIFont.TextStyle)], separator: String) {
        let nsaStrings = stringsWithStyle.map { NSAttributedString(string: $0.0, textStyle: $0.1) }
        self.init(from: nsaStrings, separator: separator)
    }

    /// Initialize from an array of NSAttributedString, joining with the separator
    /// - Parameters:
    ///   - nsaStrings: array of attributes strings
    ///   - separator: input separator
    public convenience init(from nsaStrings: [NSAttributedString], separator: String) {
        let nsaSeparator = NSAttributedString(string: separator)
        let nsmasJoined = NSMutableAttributedString()
        for (index, maString) in nsaStrings.enumerated() {
            if index > 0 { nsmasJoined.append(nsaSeparator) }
            nsmasJoined.append(maString)
        }
        self.init(attributedString: nsmasJoined)
    }
}
