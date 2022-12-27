//
//  NSAttributedStringExt.swift
//  RudifaUtilPkgDemo
//
//  Created by Rudolf Farkas on 18.10.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

#if os(iOS)

    import UIKit

    public extension NSAttributedString {
        // MARK: API initializers from array of tuples (string, attr, ...)

        /// Initialize from an array of strings with color, joining with the separator
        /// - Parameters:
        ///   - stringsWithStyle: array of tuples (string, color)
        ///   - separator: string
        convenience init(stringsWithColor: [(String, UIColor)], separator: String = " ") {
            let nsaStrings = stringsWithColor.map { NSAttributedString(string: $0.0, fgColor: $0.1) }
            self.init(from: nsaStrings, separator: separator)
        }

        /// Initialize from an array of strings with styles, joining with the separator
        /// - Parameters:
        ///   - stringsWithStyle: array of tuples (string, style)
        ///   - separator: string
        convenience init(stringsWithStyle: [(String, UIFont.TextStyle)], separator: String) {
            let nsaStrings = stringsWithStyle.map { NSAttributedString(string: $0.0, textStyle: $0.1) }
            self.init(from: nsaStrings, separator: separator)
        }

        /// Initialize from an array of strings with styles and weights, joining with the separator
        /// - Parameters:
        ///   - stringsWithStyle: array of tuples (string, style)
        ///   - separator: string
        ///   - weight: font weight, e.g. .thin
        convenience init(stringsWithStyleAndWeight: [(String, UIFont.TextStyle, weight: UIFont.Weight)], separator: String) {
            let nsaStrings = stringsWithStyleAndWeight.map { NSAttributedString(string: $0.0, textStyle: $0.1, weight: $0.2) }
            self.init(from: nsaStrings, separator: separator)
        }

        // MARK: INTERNAL simple initializers from string and specific attributes

        /// Initialize from a string using the fgColor
        /// - Parameters:
        ///   - string: input string
        ///   - color: foreground color
        convenience init(string: String, fgColor: UIColor) {
            let attributes = [NSAttributedString.Key.foregroundColor: fgColor]
            self.init(string: string, attributes: attributes)
        }

        /// Initialize from a string using the textStyle
        /// - Parameters:
        ///   - string: input string
        ///   - textStyle: input font text style
        convenience init(string: String, textStyle: UIFont.TextStyle) {
            let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: textStyle)]
            self.init(string: string, attributes: attributes)
        }

        /// Initialize from a string using the textStyle and weight
        /// - Parameters:
        ///   - string: input string
        ///   - textStyle: input font text style
        ///   - weight: font weight, e.g. .thin
        convenience init(string: String, textStyle: UIFont.TextStyle, weight: UIFont.Weight) {
            let font = UIFont.preferredFont(forTextStyle: textStyle)
            let size = font.pointSize
            let font2 = UIFont.systemFont(ofSize: size, weight: weight)
            let attributes = [NSAttributedString.Key.font: font2]
            self.init(string: string, attributes: attributes)
        }

        // MARK: INTERNAL initializer with arrays of NSAttributedString

        /// Initialize from an array of NSAttributedString, joining with the separator
        /// - Parameters:
        ///   - nsaStrings: array of attributes strings
        ///   - separator: input separator
        convenience init(from nsaStrings: [NSAttributedString], separator: String) {
            let nsaSeparator = NSAttributedString(string: separator)
            let nsmasJoined = NSMutableAttributedString()
            for (index, maString) in nsaStrings.enumerated() {
                if index > 0 { nsmasJoined.append(nsaSeparator) }
                nsmasJoined.append(maString)
            }
            self.init(attributedString: nsmasJoined)
        }
    }
#endif
