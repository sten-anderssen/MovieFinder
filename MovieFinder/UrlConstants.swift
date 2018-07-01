//
//  UrlConstants.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 01.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

struct TMDBApi {
    static let apiKey: String = "2696829a81b1b5827d515ff121700838"
    static let baseUrl: String = "https://api.themoviedb.org/3/"
    
    internal struct PathParameter {
        static let search: String = "search/"
        static let movie: String = "movie"
    }
    
    internal struct QueryParameter {
        static let query: String = "query"
        static let apiKey: String = "api_key"
        static let page: String = "page"
    }
}


