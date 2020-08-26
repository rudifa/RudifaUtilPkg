//
//  DebugExt.swift v.0.3.2
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
/// `printClassAndFunc(info: "any info")  // ---- ViewController.viewDidLoad() any info`
///
/// `printClassAndFunc(info: "@any info") // ---- 2019-12-07 18:05:39.117525 ViewController.viewDidLoad() any info`
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
/// `<key>UIFileSharingEnabled</key><true/>`
///
/// `<key>LSSupportsOpeningDocumentsInPlace</key><true/>`
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

extension NSObject {
    /// Print to stdout current class and function names and optional info
    ///
    /// - Note: Printing is enabled by DEBUG constant which is normally absent from release builds.
    ///
    /// - Requires: to be called from a subclass of NSObject
    ///
    /// - Parameters:
    ///  - info: information string; a leading "@" will be replaced by the call date
    ///  - fnc: current function (default value is the caller)
    public func printClassAndFunc(info inf_: String = "", fnc fnc_: String = #function) {
        #if DEBUG
            print(formatClassAndFunc(info: inf_, fnc: fnc_))
        #endif
    }

    /// Print to log file current class and function names and optional info
    ///
    /// - Requires: to be called from a subclass of NSObject
    ///
    /// - Parameters:
    ///  - info: information string; a leading "@" will be replaced by the call date
    ///  - fnc: current function (default value is the caller)
    public func logClassAndFunc(info inf_: String = "", fnc fnc_: String = #function) {
        Logger.shared.print(formatClassAndFunc(info: inf_, fnc: fnc_))
    }

    /// Return a string containing current class and function names and optional info
    /// - Requires: to be called from a subclass of NSObject
    /// - Parameters:
    ///  - info: information string; a leading "@" will be replaced by the call date
    ///  - fnc: current function (default value is the caller)
    public func formatClassAndFunc(info inf_: String = "", fnc fnc_: String = #function) -> String {
        var dateTime = ""
        var info = inf_
        if inf_.first == "@" {
            info = "\(inf_.dropFirst())"
            dateTime = "\(dateTimeString()) "
        }
        return "---- \(dateTime)\(String(describing: type(of: self))).\(fnc_) \(info)"
    }

    /// Return dateTimeString with microsecond resolution
    func dateTimeString() -> String {
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
            ((try? string.data(using: .utf8)?.write(to: logUrl)) as ()??)
        }
    }
}
