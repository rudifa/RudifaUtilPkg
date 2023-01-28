//
//  TimerDeltaSigma.swift
//  RudifaUtilPkg
//
//  Created by Rudolf Farkas on 06.01.23.
//  Copyright © 2023 Rudolf Farkas. All rights reserved.
//

import Foundation

/**
 ###Usage examples:###

 Sample usage:

 ````
    func demo_TimerDeltaSigma() {
        var tds = TimerDeltaSigma()
        for _ in 0 ..< 10 {
            tds.printElapsedTimes()
        }
        print()
        for _ in 0 ..< 5 {
            tds.printElapsedTimes(.ms)
        }
        print()
        for _ in 0 ..< 5 {
            tds.printElapsedTimes(.s)
        }
        print()
    }
 ```
 Sample  output:

 ```
     Δ 0.000000, Σ 0.000000 s
     Δ 0.000082, Σ 0.000082 s
     ...
     Δ 0.000022, Σ 0.000260 s
     Δ 0.000021, Σ 0.000281 s

     Δ 0.000, Σ 0.000 s
     ...
     Δ 0.000, Σ 0.000 s

     Δ 0, Σ 0 s
     ...
     Δ 0, Σ 0 s
 ```
 */

/// TimerDeltaSigma methods print elapsed time (sum since the instance creation and delta since the previous print)
public struct TimerDeltaSigma {
    public enum Format: String {
        case s
        case ms
        case μs
    }

    typealias Elapsed = (delta: TimeInterval, sigma: TimeInterval)

    /// Create an instance and start time measurement
    public init() {}

    private var initialTime: Date?
    private var previousTime: Date?

        /// Update times variables and return the result tuple
        /// - Returns: (delta, sigma)
    private mutating func elapsedTimes() -> Elapsed {
        let currentTime = Date()
        if let initialTime = initialTime, let previousTime = previousTime {
            let sigmaTime = currentTime.timeIntervalSince(initialTime)
            let deltaTime = currentTime.timeIntervalSince(previousTime)
            self.previousTime = currentTime
            return (delta: deltaTime, sigma: sigmaTime)
        } else {
            initialTime = currentTime
            previousTime = currentTime
            return (delta: 0, sigma: 0)
        }
    }

        /// Format the tuple (delta, sigma) per format `fmt`
        /// - Parameters:
        ///   - times: (delta, sigma)
        ///   - fmt: .s, .ms, .μs
        /// - Returns: formatted string, like "Δ 0.000018, Σ 0.000291 s"
    private func format(_ times: Elapsed, fmt: Format) -> String {
        switch fmt {
        case .s:
            return String(format: "Δ %.0f, Σ %.0f s", times.delta, times.sigma)
        case .ms:
            return String(format: "Δ %.3f, Σ %.3f s", times.delta, times.sigma)
        case .μs:
            return String(format: "Δ %.6f, Σ %.6f s", times.delta, times.sigma)
        }
    }

        /// Print the times: Δ since the last print, Σ since the instance creation
        /// - Parameter fmt: resolution .s, .ms, .μs
    public mutating func printElapsedTimes(_ fmt: Format = .μs) {
        print(format(elapsedTimes(), fmt: fmt))
    }
}
