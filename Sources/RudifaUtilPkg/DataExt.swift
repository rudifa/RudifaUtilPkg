//
//  DataExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 07.10.22.
//

import Foundation

public extension Data {
    /// Convert self to an Int value
    var toInt: Int {
        return withUnsafeBytes { $0.load(as: Int.self) }
    }

    /// Convert self to a binary integer value
    /// - Returns: a binary integer value
    /// - Note: annotate the return value, e.g. `var myInt: Int64 = myData.binInt()`
    func binInt<T: BinaryInteger>() -> T {
        return withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            ptr.load(as: T.self)
        }
    }
}

// MARK: read / write to a local cache file

public extension Data {
    /// Write to a cache file
    /// - Parameters:
    ///   - name: file name
    ///   - ext: file extension
    /// - Returns: URL of nil
    func writeToCacheFile(name: String, ext: String) -> URL? {
        guard let cacheFileUrl = FileManager.cacheFilePath(fileName: name, fileExt: ext) else { return nil }
        do {
            try write(to: cacheFileUrl, options: [.atomicWrite])
        } catch { return nil }
        return cacheFileUrl
    }

    /// Initialize self from a local file
    /// - Parameter url: cache file url
    init?(fromFileAt url: URL) {
        guard let data = try? Data(contentsOf: url) else { return nil }
        self = data
    }
}

public extension Data {
    /// Return string from data
    var string: String {
        String(decoding: self, as: UTF8.self)
    }

    /// Initialize self from string
    /// - Parameter string: input string
    init?(from string: String) {
        guard let data = string.data(using: .utf8) else { return nil }
        self = data
    }
}
