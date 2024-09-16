//
//  FileBackedDictionary.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 27.12.22.
//

import Foundation

/**

 Encapsulates a `[String:T]` dictionary whose values are automatically persisted (each in its own file).

 Exposes methods and properties similar to those of the Swift Dictionary.

 ###Usage examples:###

 Create a `FileBackedDictionary` instance, using Documents subdirectory named `Resources` and `struct Resource` as the value type.

  ````
       let directoryName = "Resources"
       var fbDict = FileBackedDictionary<Resource>(directoryName: directoryName)
  ````

 Add resource instances

  ````
       fbDict["apples"] = Resource(name: "apples", value: 1, quantity: 1)
       fbDict["oranges"] = Resource(name: "oranges", value: 2, quantity: 2)
       fbDict["mangos"] = Resource(name: "mangos", value: 3, quantity: 3)
  ````

 Look up the resource info

  ````
       let count = bDict.count // 3
       let keys = fbDict.keys  // ["apples", "oranges", "mangos"])
       let values = fbDict.values // ...
       let myOranges = fbDict["oranges"]
  ````

 Remove resources

 ````
        fbDict["oranges"] = nil
        fbDict.removeAll()
 ````

 At its initialization (typically at the application start), an instance of `FileBackedDictionary` recovers the keys and values from the file storage.

 */

enum FileBackedDictionaryError: Error {
    case encodingError
    case writingError(Error)
    case readingError
}

public struct FileBackedDictionary<T: Codable> {
    private(set) var dictionary: [String: T] = [:]

    private let fileManager = FileManager.default
    private let directoryURL: URL
    private func fileURL(key: String) -> URL {
        directoryURL.appendingPathComponent(key)
    }

    /// Initialize the backed-up storage
    /// - Parameter directoryName: names the backup directory
    /// - Remark: if the directory for the backup files does not exist, creates it. Initiallizes the local dict from files in the directory (if any)
    public init(directoryName: String) {
        print("FBDict: init directoryName= \(directoryName)")
        directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(directoryName)
        do {
            try ensureDirectoryExists(directoryURL: directoryURL)
            try recoverDict()
        } catch {
            print("FBDict: Initialization error: \(error)")
        }
    }

    // Delete the directory and all its contents
    public static func deleteDirectory(named directoryName: String) {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(directoryName)
        do {
            try fileManager.removeItem(at: directoryURL)
        } catch {
            print("FBDict: deleteDirectory error= \(error)")
        }
    }

    /// Ensure that the directory at the URL exists
    /// - Parameter directoryURL:
    private func ensureDirectoryExists(directoryURL: URL) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: directoryURL.path) {
            // Check if file is a directory
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    // File exists and is a directory
                    return
                }
            }
        }
        // File does not exist or is not a directory so create it
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("FBDict: Error creating directory: \(error.localizedDescription)")
            throw error
        }
    }

    /// Support for dictionary style setting and getting of a value by key
    public subscript(key: String) -> T? {
        get {
            dictionary[key]
        }
        set {
            do {
                if let value = newValue {
                    try saveValue(for: key, value: value)
                } else {
                    dictionary.removeValue(forKey: key)
                    try removeValue(forKey: key)
                }
            } catch {
                print("FBDict: Error handling value for key \(key): \(error)")
            }
        }
    }

    /// Return sorted keys
    public var keys: [String] {
        dictionary.keys.sorted().map { String($0) }
    }

    /// Return values sorted by keys
    public var values: [T] {
        keys.map { dictionary[$0]! }
    }

    /// Save the value in the dictionary and in a file
    /// - Parameters:
    ///   - key: key
    ///   - value: to be added or updated
    private mutating func saveValue(for key: String, value: T) throws {
        // Back up the dictionary value to a file named after the key
        let fileURL = fileURL(key: key)
        guard let data = try? JSONEncoder().encode(value) else {
            throw FileBackedDictionaryError.encodingError
        }

        do {
            try data.write(to: fileURL)
            guard let value = getValue(key: key) else {
                throw FileBackedDictionaryError.readingError
            }
            dictionary[key] = value
        } catch {
            throw FileBackedDictionaryError.writingError(error)
        }
    }

    /// Get the value from a file
    /// - Parameters:
    ///   - key: key
    private func getValue(key: String) -> T? {
        do {
            let data = try Data(contentsOf: fileURL(key: key))
            let dictValue = try JSONDecoder().decode(T.self, from: data)
            return dictValue
        } catch {
            print("FBDict: Error decoding data from file: \(error)")
        }
        return nil
    }

    /// Recover dictionary values from backing files
    private mutating func recoverDict() throws {
        guard let fileURLs = try? fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [], options: [.skipsHiddenFiles]) else {
            print("FBDict: recoverDict fileURLs not found")
            throw FileBackedDictionaryError.readingError
        }
        for fileURL in fileURLs {
            if let fileName = fileURL.lastPathComponent.components(separatedBy: ".").first {
                if let dictValue = getValue(key: fileName) {
                    dictionary[fileName] = dictValue
                } else {
                    print("FBDict: Error getting data from file: \(fileName)")
                    throw FileBackedDictionaryError.readingError
                }
            }
        }
    }

    /// Remove the value for key from  the dictionary and from the file
    /// - Parameter forKey: key
    public mutating func removeValue(forKey key: String) throws {
        dictionary[key] = nil
        let fileURL = fileURL(key: key)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("FBDict: removeValue \(error)")
            throw error
        }
    }

    /// Remove all values from dictionary and from files
    public mutating func removeAll() {
        do {
            let keys = try fileManager.contentsOfDirectory(atPath: directoryURL.path)
            for key in keys {
                do {
                    try removeValue(forKey: key)
                } catch {
                    print("FBDict: Error removing value for key \(key): \(error)")
                }
            }
        } catch {
            print("FBDict: removeAll error= \(error)")
        }
        dictionary = [:]
    }

    /// Return names of backing files (sorted)
    public var fileNames: [String] {
        let fileManager = FileManager.default
        var fileNames = [String]()
        guard let enumerator = fileManager.enumerator(at: directoryURL, includingPropertiesForKeys: [.nameKey], options: []) else {
            print("FBDict: enumerateFiles: no files found")
            return fileNames
        }
        for case let fileURL as URL in enumerator {
            let fileName = fileURL.lastPathComponent
            fileNames.append(fileName)
        }
        return fileNames.sorted()
    }

    /// Return the dictionary item count
    public var count: Int {
        dictionary.count
    }
}
