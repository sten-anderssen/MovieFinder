//
//  TMDBRouterTests.swift
//  MovieFinderTests
//
//  Created by Sten Anderßen on 04.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import XCTest
@testable import MovieFinder

class TMDBRouterTests: XCTestCase {
    
    func testSearchMovieAsUrlRequest() {
        // Example: http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=batman&page=1
        let apiKey = "2696829a81b1b5827d515ff121700838"
        let query = "Batman"
        let page: UInt = 1
        let parameters = [
            "api_key": apiKey,
            "query": query,
            "page": String(page)]
        let host = "api.themoviedb.org"
        let path = "/3/search/movie"
        
        do {
            let request = try TMDBRouter.search(kind: .movie, query: query, page: page).asURLRequest()
            
            guard let url = request.url, let urlHost = url.host else {
                XCTFail()
                return
            }
            XCTAssertEqual(urlHost, host, "Shoud be equal")
            XCTAssertEqual(url.path, path, "Shoud be equal")
            
            guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let queryItems = urlComponents.queryItems else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(queryItems.count, parameters.count, "Should be equal")
            
            for queryItem in queryItems {
                guard parameters.contains (where: { (key, value) -> Bool in
                    key == queryItem.name && value == queryItem.value!
                }) else {
                    XCTFail()
                    return
                }
            }
        } catch {
            XCTFail()
        }
    }
    
    func testSearchMovieWithEmptyQuery() {
        XCTAssertThrowsError(try TMDBRouter.search(kind: .movie, query: "", page: 1).asURLRequest())
    }
    
    func testSearchMovieWithPageIs0() {
        XCTAssertThrowsError(try TMDBRouter.search(kind: .movie, query: "asdf", page: 0).asURLRequest())
    }
    
    func testSearchMovieWithPageIsOver1000() {
        XCTAssertThrowsError(try TMDBRouter.search(kind: .movie, query: "asdf", page: 1001).asURLRequest())
    }
    
    func testMoviePosterAsUrlRequest() {
        // Example: http://image.tmdb.org/t/p/w92/2DtPSyODKWXluIRV7PVru0SSzja.jpg
        let host = "image.tmdb.org"
        let pathExtension = "jpg"
        let imagePath = "/2DtPSyODKWXluIRV7PVru0SSzja.\(pathExtension)"
        let path = "/t/p/w92\(imagePath)"
        
        do {
            let request = try TMDBRouter.moviePoster(size: .small, path: imagePath).asURLRequest()
            
            guard let url = request.url, let urlHost = url.host else {
                XCTFail()
                return
            }
            XCTAssertEqual(urlHost, host, "Shoud be equal")
            XCTAssertEqual(url.path, path, "Shoud be equal")
            XCTAssertEqual(url.pathExtension, pathExtension, "Should be equal")
        } catch {
            XCTFail()
        }
    }
}
