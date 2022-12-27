//
//  CGExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 31.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import CoreGraphics

// MARK: - Formatting of CG structures and scalars

public extension CGFloat {
    /// Returns a "%.3g" formatted string
    var fmt: String { return String(format: "%.3g", self) }
}

public extension CGPoint {
    /// Returns a pair of "%.2f" formatted strings
    var fmt: String { return String(format: "(%.2f, %.2f)", x, y) }
}

public extension CGSize {
    /// Returns a pair of "%.2f" formatted strings
    var fmt: String { return String(format: "(%.2f, %.2f)", width, height) }
}

public extension CGRect {
    /// Returns a quad of "%.2f" formatted strings
    var fmt: String { return "\(origin.fmt),\(size.fmt)" }
}

// MARK: - Arithmetic operations between CG structures and scalars

public extension CGSize {
    /// Multiplies a CGSize by a CGFloat
    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width * scalar, height: size.height * scalar)
    }

    /// Multiplies a CGSize by a Double
    static func * (size: CGSize, scalar: Double) -> CGSize {
        return size * CGFloat(scalar)
    }

    /// Divides a CGSize by a CGFloat
    static func / (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width / scalar, height: size.height / scalar)
    }

    /// Divides a CGSize by a Double
    static func / (size: CGSize, scalar: Double) -> CGSize {
        return size / CGFloat(scalar)
    }
}

public extension CGPoint {
    /// Multiplies a CGPoint by a CGFloat
    static func * (size: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: size.x * scalar, y: size.y * scalar)
    }

    /// Multiplies a CGPoint by a Double
    static func * (size: CGPoint, scalar: Double) -> CGPoint {
        return size * CGFloat(scalar)
    }

    /// Divides a CGPoint by a CGFloat
    static func / (size: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: size.x / scalar, y: size.y / scalar)
    }

    /// Divides a CGPoint by a Double
    static func / (size: CGPoint, scalar: Double) -> CGPoint {
        return size / CGFloat(scalar)
    }
}
