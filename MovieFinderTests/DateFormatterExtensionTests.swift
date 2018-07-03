//
//  DateFormatterExtensionTests.swift
//  MovieFinderTests
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import XCTest
@testable import MovieFinder

class DateFormatterExtensionTests: XCTestCase {

    func testYyyyMmDdFormatter() {
        let dateString = "2018-07-03"
        
        let formatter = DateFormatter.yyyyMMdd
        guard let date = formatter.date(from: dateString) else {
            XCTFail()
            return
        }
        let formattedDateString = formatter.string(from: date)
        
        XCTAssertEqual(formattedDateString, dateString, "Should be equal")
    }
}
