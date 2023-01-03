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
public struct FileBackedDictionary<T: Codable> {
    private(set) var dictionary: [String: T] = [:]

    private let fileManager = FileManager.default
    private let directoryURL: URL
    private func fileURL(key: String) -> URL {
        return directoryURL.appendingPathComponent(key)
    }

    /// Initialize the backed-up storage
    /// - Parameter directoryName: names the backup directory
    /// - Remark: if the directory for the backup files does not exist, creates it. Initiallizes the local dict from files in the directory (if any)
    public init(directoryName: String) {
        print("--- init directoryName= \(directoryName)")
        directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(directoryName)
        ensureDirectoryExists(directoryURL: directoryURL)
        recoverDict()
    }

    /// Ensure that the directory at the URL exists
    /// - Parameter directoryURL:
    private func ensureDirectoryExists(directoryURL: URL) {
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
            print("Error creating directory: \(error.localizedDescription)")
        }
    }

    /// Support for dictionary style setting and getting of a value by key
    public subscript(key: String) -> T? {
        get {
            return dictionary[key]
        }
        set {
            if let value = newValue {
                saveValue(for: key, value: value)
            } else {
                dictionary.removeValue(forKey: key)
                removeValue(forKey: key)
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
    private mutating func saveValue(for key: String, value: T) {
        dictionary[key] = value
        // Back up the dictionary value to a file named after the key
        let fileURL = self.fileURL(key: key)
        let data = try? JSONEncoder().encode(value)
        _ = fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)
    }

    /// Recover dictionary values from backing files
    private mutating func recoverDict() {
        guard let fileURLs = try? fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [], options: [.skipsHiddenFiles]) else {
            print("*** recoverDict fileURLs not found")
            return
        }
        for fileURL in fileURLs {
            if let fileName = fileURL.lastPathComponent.components(separatedBy: ".").first {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let dictValue = try JSONDecoder().decode(T.self, from: data)
                    dictionary[fileName] = dictValue
                } catch {
                    print("*** Error decoding data from file: \(error)")
                }
            }
        }
    }

    /// Remove the value for key from  the dictionary and from the file
    /// - Parameter forKey: key
    public mutating func removeValue(forKey key: String) {
        dictionary[key] = nil
        let fileURL = self.fileURL(key: key)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("*** removeValue \(error)")
        }
    }

    /// Remove all values from dictionary and from files
    public mutating func removeAll() {
        do {
            for key in try fileManager.contentsOfDirectory(atPath: directoryURL.path) {
                removeValue(forKey: key)
            }
        } catch {
            print("*** removeAll error= \(error)")
        }
        dictionary = [:]
    }

    /// Print names of backing files
    private func enumerateFiles() {
        let fileManager = FileManager.default
        guard let enumerator = fileManager.enumerator(at: directoryURL, includingPropertiesForKeys: [.nameKey], options: [.skipsHiddenFiles]) else {
            print("enumerateFiles: no files found")
            return
        }
        for case let fileURL as URL in enumerator {
            let fileName = fileURL.lastPathComponent
            print("enumerateFiles: \(fileName)")
        }
    }

    /// Return the dictionary item count
    public var count: Int {
        //        do { // for debugging only
        //            // check the number of files in the directory
        //            let fileNames = try fileManager.contentsOfDirectory(atPath: directoryURL.path)
        //            if fileNames.count != dictionary.count {
        //                print("*** count directoryURL= \(directoryURL)")
        //                print("*** count fileNames= \(fileNames)")
        //                print("*** count keys= \(dictionary.keys)")
        //            }
        //        } catch {
        //            print("Error while enumerating files \(directoryURL.path): \(error.localizedDescription)")
        //        }
        return dictionary.count
    }
}
