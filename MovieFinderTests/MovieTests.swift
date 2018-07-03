//
//  MovieTests.swift
//  MovieFinderTests
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import XCTest
@testable import MovieFinder

class MovieTests: XCTestCase {

    func testInitWithCoder() {
        let id = 123456789
        let title = "title"
        let posterPath = "null"
        let overview = "overview"
        let dateString = "2018-07-03"
        
        let jsonString = """
            {
                "id":\(id),
                "title":"\(title)",
                "poster_path":\(posterPath),
                "adult":false,
                "overview":"\(overview)",
                "release_date":"\(dateString)"
            }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
            let movie = try decoder.decode(Movie.self, from: jsonData)
            
            XCTAssertNotNil(movie, "Should not be nil")
            XCTAssertEqual(movie.id, id, "Should be equal")
            XCTAssertEqual(movie.title, title, "Should be equal")
            XCTAssertEqual(movie.overview, overview, "Should be equal")

            let formatter = DateFormatter.yyyyMMdd
            let movieReleaseDateString = formatter.string(from: movie.releaseDate)
            XCTAssertEqual(movieReleaseDateString, dateString, "Should be equal")
            
            XCTAssertNil(movie.posterPath, "Should be nil")
        } catch {
            XCTFail()
        }
        
    }
}
