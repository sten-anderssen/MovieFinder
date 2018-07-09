//
//  PersistenceManagerTest.swift
//  MovieFinderTests
//
//  Created by Sten Anderßen on 09.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import XCTest
@testable import MovieFinder

class PersistenceManagerTest: XCTestCase {

    override func setUp() {
        resetStore()
    }
    
    override func tearDown() {
        resetStore()
    }
    
    func testSafeSearchQuery() {
        let query = Query(value: "test", date: Date())
        
        do {
            try PersistenceManager.shared.save(query)
        } catch {
            XCTFail()
        }
    }
    
    func testDuplicateSearchQuery() {
        let query1 = Query(value: "test", date: Date())
        let query2 = Query(value: "test", date: Date())
        
        do {
            try PersistenceManager.shared.save(query1)
            try PersistenceManager.shared.save(query2)
        } catch {
            XCTFail()
        }
        
        let recentSearchQueries = PersistenceManager.shared.fetchRecentSearchQueries()
        XCTAssertFalse(recentSearchQueries.isEmpty, "Should not be empty")
        XCTAssertTrue(recentSearchQueries.count == 1, "Should have only one element")
        
        guard let recentSearchQuery = recentSearchQueries.first else {
            XCTFail()
            return
        }
        XCTAssertEqual(recentSearchQuery.date, query2.date, "Should have the same date")
    }
    
    func testMaxSearchQueries() {
        let maxSearchQueries = PersistenceManager.shared.kMaxSearchQueries
        for index in 0...maxSearchQueries + 1 {
            do {
                let query = Query(value: "test"+String(index), date: Date())
                try PersistenceManager.shared.save(query)
            } catch {
                XCTFail()
            }
        }
        
        let recentSearchQueries = PersistenceManager.shared.fetchRecentSearchQueries()
        XCTAssertTrue(recentSearchQueries.count == maxSearchQueries, "Should no exceed query limit")
    }
    
    private func resetStore() {
        let fileManager = FileManager.default
        if let fileUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            try? fileManager.removeItem(atPath: fileUrl.path)
        }
    }
}
