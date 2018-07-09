//
//  Query.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 08.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

/// Model class that holds data for a search query. Is storeable in a persistent store.
struct Query: Storeable {
    let value: String
    let date: Date
}

extension Query: Codable {
    enum QueryCodingKeys: String, CodingKey {
        case value = "value"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QueryCodingKeys.self)
        let value = try container.decode(String.self, forKey: .value)
        let date = try container.decode(Date.self, forKey: .date)
        
        self.init(value: value, date: date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: QueryCodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(date, forKey: .date)
    }
}

extension Query: Equatable {
    
    /// Query elements are equal when each value and date contents are equal
    static func == (lhs: Query, rhs: Query) -> Bool {
        return lhs.value == rhs.value && lhs.date == rhs.date
    }
}

extension Sequence where Iterator.Element == Query {
    
    /// Returns array sorted for date in ascending order
    func sorted() -> [Query] {
        return self.sorted(by: { $0.date > $1.date })
    }
}
