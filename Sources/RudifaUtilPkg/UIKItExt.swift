//
//  UIKItExt.swift
//
//
//  Created by Rudolf Farkas on 07.01.23.
//  Copyright © 2023 Rudolf Farkas. All rights reserved.
//

#if os(iOS)
    import UIKit

    extension UIImage {
        /// Return a summary of inmage size data
        /// - Example: (700.0, 700.0) x 1.0, 609693 bytes
        var summary: String {
            let data = jpegData(compressionQuality: 1.0) ?? pngData()
            let bytes = "\(data?.count ?? 0)"
            return "\(size) x \(scale), \(bytes) bytes"
        }
    }
#endif
