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
    
    private static let baseUrlString: String = "https://api.themoviedb.org/3/"
    private static let apiKey: String = "2696829a81b1b5827d515ff121700838"

    internal enum TMDBSearchKind: String {
        case movie
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search(let kind, _, _):
            return "search/" + kind.rawValue
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .search(_, let query, let page):
            return [
                "api_key": TMDBRouter.apiKey,
                "query": query,
                "page": String(page)
            ]
        }
    }

    
    func asURLRequest() throws -> URLRequest {
        let url = try TMDBRouter.baseUrlString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .search:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
