//
//  SearchQueryManager.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 07.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

class SearchQueryManager {
    
    static let shared = SearchQueryManager()
    
    private let kMaxSearchQueries = 10
    private var queries = [String]()
    
    private init() {}
    
    func save(_ searchQuery: String) {
        if queries.count >= kMaxSearchQueries {
            let _ = queries.popLast()
        }
        queries.insert(searchQuery, at: 0)
    }
    
    func retrieveRecentSearchQueries() -> [String] {
        return queries
    }
}
