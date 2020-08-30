# RudifaUtilPkg

Package contains extensions and utility methods.

###NOTES

#### error running  `swift test` in terminal
    "/**/DateIntervalExt.swift:13:11: error: 'DateInterval' is only available in macOS 10.12 or newer"

Fix: add `.macOS(.v10_12)` in

    let package = Package(
        name: "RudifaUtilPkg",
        platforms: [
           .iOS(.v10), .macOS(.v10_12),
        ],
