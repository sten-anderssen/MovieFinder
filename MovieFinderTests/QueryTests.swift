//
//  QueryTests.swift
//  MovieFinderTests
//
//  Created by Sten Anderßen on 09.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import XCTest
@testable import MovieFinder

class QueryTests: XCTestCase {
    
    func testCodable() {
        let value = "test"
        let date = Date()
        let query = Query(value: value, date: date)
        
        do {
            let data = try JSONEncoder().encode(query)
            XCTAssertNotNil(data, "Should not be nil")
            
            let query = try JSONDecoder().decode(Query.self, from: data)
            XCTAssertEqual(query.value, value, "Should be equal")
            XCTAssertEqual(query.date, date, "Should be equal")
        } catch {
            XCTFail()
        }
    }
    
    func testEquatable() {
        let value = "test"
        let value2 = "test2"
        let date = Date()
        let date2 = Date.distantFuture
        
        let query1 = Query(value: value, date: date)
        let query2 = Query(value: value, date: date)
        XCTAssertEqual(query1, query2, "Should be equal")
        
        let query3 = Query(value: value, date: date2)
        XCTAssertNotEqual(query1, query3, "Should not be equal")
        
        let query4 = Query(value: value2, date: date)
        XCTAssertNotEqual(query2, query4, "Should not be equal")

        let query5 = Query(value: value2, date: date2)
        XCTAssertNotEqual(query1, query5, "Should not be equal")
    }
    
    func testSorted() {
        let now = Date()
        let yesterday = Date(timeIntervalSinceNow: -(60*60*24))
        let past = Date.distantPast
        
        let queryYesterDay = Query(value: "test", date: yesterday)
        let queryNew = Query(value: "test", date: now)
        let queryPast = Query(value: "test", date: past)
        
        let unsorted = [queryPast, queryNew, queryYesterDay]
        let sorted = unsorted.sorted()
        
        guard let firstQuery = sorted.first, let lastQuery = sorted.last else {
            XCTFail()
            return
        }
        let secondQuery = sorted[1]
        
        XCTAssertEqual(firstQuery, queryNew, "Should be the newest query")
        XCTAssertEqual(secondQuery, queryYesterDay, "Should be the query from yesterday")
        XCTAssertEqual(lastQuery, queryPast, "Should be the query from the distant past")
    }
}
