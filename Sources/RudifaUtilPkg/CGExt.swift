//
//  CGExt.swift v.0.1.2
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 31.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import CoreGraphics

// MARK: - Formatting of CG structures and scalars

extension CGFloat {
    /// Returns a "%.3g" formatted string
    public var fmt: String { return String(format: "%.3g", self) }
}

extension CGPoint {
    /// Returns a pair of "%.2f" formatted strings
    public var fmt: String { return String(format: "(%.2f, %.2f)", x, y) }
}

extension CGSize {
    /// Returns a pair of "%.2f" formatted strings
    public var fmt: String { return String(format: "(%.2f, %.2f)", width, height) }
}

extension CGRect {
    /// Returns a quad of "%.2f" formatted strings
    public var fmt: String { return "\(origin.fmt),\(size.fmt)" }
}

// MARK: - Arithmetic operations between CG structures and scalars

extension CGSize {
    /// Multiplies a CGSize by a CGFloat
    public static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width * scalar, height: size.height * scalar)
    }

    /// Multiplies a CGSize by a Double
    public static func * (size: CGSize, scalar: Double) -> CGSize {
        return size * CGFloat(scalar)
    }

    /// Divides a CGSize by a CGFloat
    public static func / (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width / scalar, height: size.height / scalar)
    }

    /// Divides a CGSize by a Double
    public static func / (size: CGSize, scalar: Double) -> CGSize {
        return size / CGFloat(scalar)
    }
}

extension CGPoint {
    /// Multiplies a CGPoint by a CGFloat
    public static func * (size: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: size.x * scalar, y: size.y * scalar)
    }

    /// Multiplies a CGPoint by a Double
    public static func * (size: CGPoint, scalar: Double) -> CGPoint {
        return size * CGFloat(scalar)
    }

    /// Divides a CGPoint by a CGFloat
    public static func / (size: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: size.x / scalar, y: size.y / scalar)
    }

    /// Divides a CGPoint by a Double
    public static func / (size: CGPoint, scalar: Double) -> CGPoint {
        return size / CGFloat(scalar)
    }
}
