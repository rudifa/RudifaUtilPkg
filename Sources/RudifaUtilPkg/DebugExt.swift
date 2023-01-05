//
//  DebugExt.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 23.07.19.
//  Copyright © 2019 Rudolf Farkas. All rights reserved.
//

import Foundation

///  Usage of logging utilities
///
///  Log to stdout (Xcode console)
///
/// `print("any info")`
///
/// `printClassAndFunc("any info")  // ---- ViewController.viewDidLoad() any info`
///
/// `printClassAndFunc("@any info") // ---- 2019-12-07 18:05:39.117525 ViewController.viewDidLoad() any info`
///
/// Log to the app's logfile "Log.txt"
///
/// `Logger.shared.print("any info")`
///
/// `logClassAndFunc(info: "any info")  // ---- ViewController.viewDidLoad() any info`
///
/// `logClassAndFunc(info: "@any info") // ---- 2019-12-07 18:05:39.117525 ViewController.viewDidLoad() any info`
///
/// View the log file captured on the iOS device:
///
/// - Add to app's info.plist 2 keys:
///
/// | Application supports iTunes file sharing | YES | <key>UIFileSharingEnabled</key><true/> |
///
/// | Supports opening documents in place      | YES | <key>LSSupportsOpeningDocumentsInPlace</key><true/> |
///
/// - Connect iOS device to the Mac via cable or WiFi
///
/// - Open the device in Finder
///
/// - Open the Files tab
///
/// - Open the app's directory
///
/// - Drag the file "Log.txt" to the desktop and open it in a text editor
///
/// Delete the log file captured on the iOS device:
///
/// - Open the app's directory as above, right-click on the file and click `Delete`

public extension NSObject {
    // MARK: print to console (DEBUG only)

    /// Print to stdout current class and function names and optional info
    ///
    /// - Note: Printing is enabled by DEBUG constant which is normally absent from release builds.
    ///
    /// - Requires: to be called from a subclass of NSObject
    ///
    /// - Parameters:
    ///  - info: information string; a leading "@" will be replaced by the call date
    ///  - fnc: current function (default value is the caller)
    @available(*, deprecated, message: "use printClassAndFunc(\"...\" instead")
    func printClassAndFunc(info inf_: String = "", fnc fnc_: String = #function) {
        #if DEBUG
            print(formatClassAndFunc(info: inf_, fnc: fnc_))
        #endif
    }

    /// Print to stdout current class and function names and optional info
    ///
    /// - Note: Printing is enabled by DEBUG constant which is normally absent from release builds.
    ///
    /// - Requires: to be called from a subclass of NSObject
    ///
    /// - Parameters:
    ///  - _: information string; a leading "@" will be replaced by the call date
    ///  - fnc: current function (default value is the caller)
    func printClassAndFunc(_ info: String = "", fnc fnc_: String = #function) {
        #if DEBUG
            print(formatClassAndFunc(info: info, fnc: fnc_))
        #endif
    }

    /// Print to stdout current class and function names and optional info
    ///
    /// - Note: This third form is only needed to make the call printClassAndFunc() unambigous
    ///         when both above forms are present in the code.
    ///
    /// - TODO: remove when the above deprecated form is removed
    ///
    func printClassAndFunc(_fnc fnc_: String = #function) {
        #if DEBUG
            print(formatClassAndFunc(info: "", fnc: fnc_))
        #endif
    }

    // MARK: log to file log.txt

    /// Print to log file current class and function names and optional info
    ///
    /// - Requires: to be called from a subclass of NSObject
    ///
    /// - Parameters:
    ///  - info: information string; a leading "@" will be replaced by the call date
    ///  - fnc: current function (default value is the caller)
    @available(*, deprecated, message: "use logClassAndFunc(\"...\" instead")
    func logClassAndFunc(info inf_: String = "", fnc fnc_: String = #function) {
        Logger.shared.print(formatClassAndFunc(info: inf_, fnc: fnc_))
    }

    /// Print to log file current class and function names and optional info
    ///
    /// - Note: Printing is enabled by DEBUG constant which is normally absent from release builds.
    ///
    /// - Requires: to be called from a subclass of NSObject
    ///
    /// - Parameters:
    ///  - _: information string; a leading "@" will be replaced by the call date
    ///  - fnc: current function (default value is the caller)
    func logClassAndFunc(_ info: String = "", fnc fnc_: String = #function) {
        Logger.shared.print(formatClassAndFunc(info: info, fnc: fnc_))
    }

    /// Print to log file current class and function names and optional info
    ///
    /// - Note: This third form is only needed to make the call logClassAndFunc() unambigous
    ///         when both above forms are present in the code.
    ///
    /// - TODO: remove when the above deprecated form is removed
    ///
    func logClassAndFunc(_fnc fnc_: String = #function) {
        Logger.shared.print(formatClassAndFunc(info: "", fnc: fnc_))
    }

    // MARK: supporting functions

    /// Return a string containing current class and function names and optional info
    /// - Requires: to be called from a subclass of NSObject
    /// - Parameters:
    ///  - info: information string; a leading "@" will be replaced by the call date
    ///  - fnc: current function (default value is the caller)
    internal func formatClassAndFunc(info inf_: String = "", fnc fnc_: String = #function) -> String {
        var dateTime = ""
        var info = inf_
        if inf_.first == "@" {
            info = "\(inf_.dropFirst())"
            dateTime = "\(dateTimeString()) "
        }
        return "---- \(dateTime)\(String(describing: type(of: self))).\(fnc_) \(info)"
    }

    /// Return dateTimeString with microsecond resolution
    internal func dateTimeString() -> String {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond],
                                       from: Date())
        let microSeconds = lrint(Double(comps.nanosecond!) / 1000) // Divide by 1000 and round

        let formatted = String(format: "%04ld-%02ld-%02ld %02ld:%02ld:%02ld.%06ld",
                               comps.year!, comps.month!, comps.day!,
                               comps.hour!, comps.minute!, comps.second!,
                               microSeconds)
        return formatted
    }
}

/// Helper for logging to logfile
class Logger: TextOutputStream {
    static let shared = Logger()
    let logfile = "Log.txt"
    let logUrl: URL

    private init() {
        let fm = FileManager.default
        logUrl = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(logfile)
    }

    /// Print string and newline to logfile
    /// - Parameter string: string to print
    func print(_ string: String) {
        write(string + "\n")
    }

    internal func write(_ string: String) {
        if let handle = try? FileHandle(forWritingTo: logUrl) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            (try? string.data(using: .utf8)?.write(to: logUrl)) as ()??
        }
    }
}
