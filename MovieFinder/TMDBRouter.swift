//
//  TMDBUrlBuilder.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 01.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Alamofire

enum TMDBRouter: URLRequestConvertible {

    case search(kind: TMDBSearchKind, query: String, page: UInt)
    case moviePoster(path: String)
    
    private static let apiKey: String = "2696829a81b1b5827d515ff121700838"

    internal enum TMDBSearchKind: String {
        case movie
    }
    
    var baseUrlString: String {
        switch self {
        case .search:
            return "https://api.themoviedb.org/3/"
        case .moviePoster:
            return "https://image.tmdb.org/t/p/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        case .moviePoster:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search(let kind, _, _):
            return "search/" + kind.rawValue
        case .moviePoster(let path):
            return "w92" + path
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .search(_, let query, let page):
            return [
                "api_key": TMDBRouter.apiKey,
                "query": query,
                "page": String(page),
                "include_adult": "true"
            ]
        default:
            return [:]
        }
    }

    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrlString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        
        return urlRequest
    }
}
