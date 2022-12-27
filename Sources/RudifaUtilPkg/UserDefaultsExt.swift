//
//  UserDefaultsExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 13.03.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import Foundation

/** Usage notes: CodableUserDefault<Key, Value> vs. PlistUserDefault<Key, Value>

 PlistUserDefault supports plist-compatible types: Data, String, Number, Date, Array and Dictionary.

 CodableUserDefault supports any type conforming to the Codable protocol (which includes plist-compatible types,
 but also structs and enums conforming to Codable.

 Note:
 PlistUserDefault must be used for settings declared in Settings.bundle/Root.plist (because these are
 stored in type-specific formats, while CodableUserDefault stores/retrieves all types as Data).
 */

/// Wrapper CodableUserDefault<Key, Value>
/// enables creation of variables of any type conforming to Codable protocol
@propertyWrapper
public struct CodableUserDefault<Key: RawRepresentable, Value: Codable> where Key.RawValue == String {
    let key: Key
    let defaultValue: Value
    private var userDefaults: UserDefaults

    public init(key: Key, defaultValue: Value, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: Value {
        get {
            var value = defaultValue
            if let data = userDefaults.data(forKey: key.rawValue) {
                do {
                    value = try JSONDecoder().decode(Value.self, from: data)
                } catch {}
            }
            return value
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: key.rawValue)
        }
    }
}

/// Wrapper PlistUserDefault<Key, Value>
/// enables creation of variables of any .plist-compatible type
/// (Data, String, Number, Date, Array and Dictionary)
@propertyWrapper
public struct PlistUserDefault<Key: RawRepresentable, Value> where Key.RawValue == String {
    let key: Key
    let defaultValue: Value
    var userDefaults: UserDefaults = .standard

    public init(key: Key, defaultValue: Value, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: Value {
        get {
            let value = userDefaults.value(forKey: key.rawValue) as? Value
            return value ?? defaultValue
        }
        set {
            userDefaults.setValue(newValue, forKey: key.rawValue)
        }
    }
}
