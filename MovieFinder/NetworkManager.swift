//
//  NetworkManager.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 01.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit

enum NetworkError: Error {
    
    case badRequest
    case internalError
    case invalidResponse
    case noConnection
    case serverError
    case network(error: Error)
    
    init(_ error: Error) {
        let error = error as NSError
        
        switch error.code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorInternationalRoamingOff, NSURLErrorDataNotAllowed, NSURLErrorNetworkConnectionLost:
            self = .noConnection
        case NSURLErrorTimedOut, NSURLErrorCannotFindHost, NSURLErrorDNSLookupFailed, NSURLErrorCannotConnectToHost, NSURLErrorResourceUnavailable, NSURLErrorBackgroundSessionWasDisconnected, NSURLErrorCannotLoadFromNetwork:
            if NetworkManager.shared.isNetworkReachable {
                self = .serverError
            } else {
                self = .noConnection
            }
        default:
            self = .network(error: error)
        }
    }
}

/// Manager class that is responsible for any network request a view needs for displaying data from an API.
class NetworkManager {
    
    static let shared = NetworkManager()
    let session: SessionManager
    
    /// Returns network reachability as a boolean.
    var isNetworkReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    private init() {
        // Create default url configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        session = Alamofire.SessionManager(configuration: configuration)
    }
    
    // MARK: - TMDB API
    
    /// Querys TMDB movie database for a given search string.
    ///
    /// - Parameters:
    ///   - searchString: The search string e.g. "Batman"
    ///   - page: The result page number
    ///   - onSuccess: The success block if the network request was successful with found movies
    ///   - onFailure: The failure block if the network request failed with error
    /// - Returns: A DataRequest object
    func searchMovies(for searchString: String, page: UInt, onSuccess: @escaping ([Movie]) -> Void, onFailure: @escaping (NetworkError) -> Void) throws -> DataRequest {
        return session.request(TMDBRouter.search(kind: .movie, query: searchString, page: page))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        guard let json = response.data else {
                            onFailure(.internalError)
                            return
                        }
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                        let result = try decoder.decode(MovieResult.self, from: json)
                        onSuccess(result.movies)
                    } catch {
                        onFailure(.invalidResponse)
                    }
                case .failure(let error):
                    onFailure(NetworkError(error))
                }
        }
    }
}
