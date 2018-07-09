//
//  SearchQueryManager.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 07.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    let kMaxSearchQueries = 10
    
    // Use NSKeyedArchiver as persistence strategy
    let persistenceController = CodingPersistenceController()
    
    private init() {}
    
    func save(_ searchQuery: Query) throws {
        let storedQueries = fetchRecentSearchQueries()
        
        // Remove query if there is already a search query with the same value
        if let storedQuery = storedQueries.first( where: { $0.value == searchQuery.value }) {
            try persistenceController.remove(storedQuery)
        }
        
        // If the maximum count of search queries is reached remove the oldest query
         else if storedQueries.count >= kMaxSearchQueries {
            let orderedQueries = storedQueries.sorted()
            if let lastQuery = orderedQueries.last {
                try persistenceController.remove(lastQuery)
            }
        }
        try persistenceController.insert(searchQuery)
    }
    
    func fetchRecentSearchQueries() -> [Query] {
        return persistenceController.findAll(Query.self).sorted()
    }
    
    /// Save all changes to a persistence store. Should be called before data gets lost otherwise.
    func save() {
        try? persistenceController.save()
    }
}
