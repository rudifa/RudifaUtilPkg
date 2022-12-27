//
//  FileManagerExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 05.09.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import Foundation

public extension FileManager {
    /// Create path to a cache file
    /// - Parameters:
    ///   - fileName: filenamne
    ///   - fileExt: extension
    /// - Returns: file URL
    static func cacheFilePath(fileName: String, fileExt: String) -> URL? {
        guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }

        let filePath = directoryURL.appendingPathComponent(fileName).appendingPathExtension(fileExt)
        print("==== cacheFilePath = ", filePath.absoluteString)
        return filePath
    }
}

// try data.write(to: fileURL, options: [.atomicWrite])

// guard let data = try? Data(contentsOf: url) else { return nil }
