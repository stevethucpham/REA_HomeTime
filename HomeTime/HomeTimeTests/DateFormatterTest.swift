//
//  Copyright (c) 2015 REA. All rights reserved.
//

import UIKit
import Foundation
import XCTest
@testable import HomeTime

class DateFormatterTest: XCTestCase {
    
    var currentTestingTime: Date!
    
     override func setUp() {
        currentTestingTime = Date("15:10")
    }
    
    func testShouldConvertTimeIntervalToDateString() {
        let converter = DotNetDateConverter()
        let result = converter.formattedDateFromString("/Date(1426821588000+1100)/")
        XCTAssertEqual(result, "02:19 PM")
    }
    
    func testTimeIn12HourFormat() {
        let expectedTime = currentTestingTime.timeIn12HourFormat()
        XCTAssertEqual(expectedTime, "03:10 PM")
    }
    
    func testTimeDifferenceWithHoursMinutes() {
        let sinceTime = Date("17:20")
        let expectedTime = currentTestingTime.timeDifference(since: sinceTime)
        XCTAssertEqual(expectedTime, "2 hours 10 minutes")
    }
    
    func testTimeDifferenceWithMinutes() {
        let sinceTime = Date("15:20")
        let expectedTime = currentTestingTime.timeDifference(since: sinceTime)
        XCTAssertEqual(expectedTime, "10 minutes")
    }
    
    func testTimeDifferenceWithNow() {
        let sinceTime = Date("15:10")
        let expectedTime = currentTestingTime.timeDifference(since: sinceTime)
        XCTAssertEqual(expectedTime, "now")
    }
    
    
}
