//
//  TimerDeltaSigmaTests.swift
//
//
//  Created by Rudolf Farkas on 06.01.23.
//

import XCTest
import RudifaUtilPkg

final class TimerDeltaSigmaTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_TimerDeltaSigma() {
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
}
