//
//  TMDBUrlBuilder.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 01.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

class TMDBUrlBuilder {
    
    static func createSearchMovieUrl(for searchTerm: String, page: UInt) throws -> URL? {
        let parameters = [TMDBApi.QueryParameter.query: searchTerm, TMDBApi.QueryParameter.page: String(page)]
        return try UrlBuilderUtils.createRequestUrl(path: createRequestPath(queryPath: TMDBApi.PathParameter.search + TMDBApi.PathParameter.movie), parameters: createRequestParameters(queryParameters: parameters))
    }
    
    private static func createRequestPath(queryPath: String) -> String {
        return TMDBApi.baseUrl + queryPath
    }
    
    private static func createRequestParameters(queryParameters: [String : String]) -> [String: String] {
        return [TMDBApi.QueryParameter.apiKey: TMDBApi.apiKey].merging(queryParameters, uniquingKeysWith: { (a, _) in a })
    }
}
