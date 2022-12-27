//
//  UserDefaultsExtTests.swift
//  RudifaUtilPkgTests
//
//  Created by Rudolf Farkas on 13.03.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

@testable import RudifaUtilPkg
import XCTest

/// Return the approximate number of seconds in a year
let yearInSeconds = TimeInterval(365 * 24 * 60 * 60)

final class UserDefaultsExtTests: XCTestCase {
    func test_CodableUserDefault() {
        // A struct that an app wants to save in UserDefaults
        struct SubscriptionInfo: Codable, Equatable {
            let productId: String
            let purchaseDate: Date?
        }

        // define several defaults, like an app would do,
        // for storage in UserDefaults.standard (local to the app)
        enum LocalCodableDefaults {
            // define keys to defaults
            enum Key: String {
                case userId
                case subscriptionInfo
            }

            @CodableUserDefault(key: Key.userId,
                                defaultValue: "UNKNOWN")
            static var userId: String

            @CodableUserDefault(key: Key.subscriptionInfo,
                                defaultValue: SubscriptionInfo(productId: "ABBA",
                                                               purchaseDate: Date(timeIntervalSince1970: 2 * yearInSeconds)))
            static var subscriptionInfo: SubscriptionInfo
        }

        // define several defaults, like an app would do,
        // for storage in sharedDefaults (shared among several apps)
        enum SharedCodableDefaults {
            // store shared among several apps
            static let sharedDefaults = UserDefaults(suiteName: "group.com.share-telematics.calshare")!

            // keys to defaults
            enum Key: String {
                case selectedCalendarTitle
                case calendarTitles
            }

            @CodableUserDefault(key: Key.calendarTitles,
                                defaultValue: [],
                                userDefaults: sharedDefaults)
            static var calendarTitles: [String]

            @CodableUserDefault(key: Key.selectedCalendarTitle,
                                defaultValue: "Select a calendar...",
                                userDefaults: sharedDefaults)
            static var selectedCalendarTitle: String
        }

        // restore to default values
        LocalCodableDefaults.userId = "UNKNOWN"
        LocalCodableDefaults.subscriptionInfo = SubscriptionInfo(productId: "ABBA", purchaseDate: Date(timeIntervalSince1970: 2 * yearInSeconds))
        SharedCodableDefaults.calendarTitles = []
        SharedCodableDefaults.selectedCalendarTitle = "Select a calendar..."

        XCTAssertEqual(LocalCodableDefaults.userId, "UNKNOWN")
        XCTAssertEqual(LocalCodableDefaults.subscriptionInfo, SubscriptionInfo(productId: "ABBA", purchaseDate: Date(timeIntervalSince1970: 2 * yearInSeconds)))
        XCTAssertEqual(SharedCodableDefaults.calendarTitles, [])
        XCTAssertEqual(SharedCodableDefaults.selectedCalendarTitle, "Select a calendar...")

        // modify default values
        LocalCodableDefaults.userId = "Wendy"
        LocalCodableDefaults.subscriptionInfo = SubscriptionInfo(productId: "DADA", purchaseDate: Date(timeIntervalSince1970: -55 * yearInSeconds))
        SharedCodableDefaults.calendarTitles = ["Code_Cal", "Home", "Work"]
        SharedCodableDefaults.selectedCalendarTitle = "Code_Cal"

        XCTAssertEqual(LocalCodableDefaults.userId, "Wendy")
        XCTAssertEqual(LocalCodableDefaults.subscriptionInfo, SubscriptionInfo(productId: "DADA", purchaseDate: Date(timeIntervalSince1970: -55 * yearInSeconds)))
        XCTAssertEqual(SharedCodableDefaults.calendarTitles, ["Code_Cal", "Home", "Work"])
        XCTAssertEqual(SharedCodableDefaults.selectedCalendarTitle, "Code_Cal")
    }

    func test_PlistUserDefault() {
        // A struct that an app wants to save in UserDefaults
        struct SubscriptionInfo: Codable, Equatable {
            let productId: String
            let purchaseDate: Date?
        }

        // define several defaults, like an app would do,
        // for storage in UserDefaults.standard (local to the app)
        enum LocalAndSharedDefaults {
            static let sharedDefaults = UserDefaults(suiteName: "group.com.share-telematics.calshare")!

            // define keys to defaults
            enum Key: String {
                case userId2
                case selectedCalendarTitle
                case calendarTitles
            }

            @PlistUserDefault(key: Key.userId2,
                              defaultValue: "UNKNOWN")
            static var userId: String

            @PlistUserDefault(key: Key.calendarTitles,
                              defaultValue: [],
                              userDefaults: sharedDefaults)
            static var calendarTitles: [String]

            @PlistUserDefault(key: Key.selectedCalendarTitle,
                              defaultValue: "Select a calendar...",
                              userDefaults: sharedDefaults)
            static var selectedCalendarTitle: String
        }

        // restore to default values

        LocalAndSharedDefaults.userId = "UNKNOWN"

        LocalAndSharedDefaults.calendarTitles = []
        LocalAndSharedDefaults.selectedCalendarTitle = "Select a calendar..."

        XCTAssertEqual(LocalAndSharedDefaults.userId, "UNKNOWN")

        XCTAssertEqual(LocalAndSharedDefaults.calendarTitles, [])
        XCTAssertEqual(LocalAndSharedDefaults.selectedCalendarTitle, "Select a calendar...")

        // modify default values
        LocalAndSharedDefaults.userId = "Wendy"

        LocalAndSharedDefaults.calendarTitles = ["Code_Cal", "Home", "Work"]
        LocalAndSharedDefaults.selectedCalendarTitle = "Code_Cal"

        XCTAssertEqual(LocalAndSharedDefaults.userId, "Wendy")

        XCTAssertEqual(LocalAndSharedDefaults.calendarTitles, ["Code_Cal", "Home", "Work"])
        XCTAssertEqual(LocalAndSharedDefaults.selectedCalendarTitle, "Code_Cal")
    }
}
