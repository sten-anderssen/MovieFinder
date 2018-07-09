//
//  TMDBUrlBuilder.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 01.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Alamofire

/// Router class that creates url requests for the TMDB API.
enum TMDBRouter: URLRequestConvertible {

    case search(kind: TMDBSearchKind, query: String, page: UInt)
    case moviePoster(size: TMDBPosterSize, path: String)
    
    private static let apiKey: String = "2696829a81b1b5827d515ff121700838"

    internal enum TMDBSearchKind: String {
        case movie
    }
    
    internal enum TMDBPosterSize: String {
        case small = "w92"
        case medium = "w185"
        case large = "w500"
    }
    
    private var baseUrlString: String {
        switch self {
        case .search:
            return "https://api.themoviedb.org/3/"
        case .moviePoster:
            return "https://image.tmdb.org/t/p/"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        case .moviePoster:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .search(let kind, _, _):
            return "search/" + kind.rawValue
        case .moviePoster(let size, let path):
            return size.rawValue + path
        }
    }
    
    private var parameters: [String: String] {
        switch self {
        case .search(_, let query, let page):
            return [
                "api_key": TMDBRouter.apiKey,
                "query": query,
                "page": String(page),
            ]
        default:
            return [:]
        }
    }

    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrlString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .search(_, let query, let page):
            guard (1...1000).contains(page), !query.isEmpty else {
                throw NetworkError.badRequest
            }
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
