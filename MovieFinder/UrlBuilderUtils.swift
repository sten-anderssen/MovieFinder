//
//  UrlBuilderUtils.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 01.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

class UrlBuilderUtils {
    
    static func createRequestUrl(path: String, parameters: [String: String]) throws -> URL? {
        var urlComponent = URLComponents(string: path)
        urlComponent?.queryItems = parameters.map { (query, value) in
            return URLQueryItem(name: query, value: value)
        }
        return try urlComponent?.asURL()
    }
}
