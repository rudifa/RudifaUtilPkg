//
//  ClassExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 29.09.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import Foundation

#if os(iOS)

    // from https://dev.to/tattn/my-favorite--swift-extensions-8g7 by Tatsuya Tanaka

    /// Requires the conforming classes to provide a class property and an instance property .className
    public protocol ClassNameProtocol {
        static var className: String { get }
        var className: String { get }
    }

    /// Implements the class property and the instance property .className required by ClassNameProtocol
    public extension ClassNameProtocol {
        static var className: String {
            return String(describing: self)
        }

        var className: String {
            return type(of: self).className
        }
    }

    /// Extends the NSObject
    extension NSObject: ClassNameProtocol {}

#endif
