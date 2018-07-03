//
//  NetworkManager.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 01.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkError: Error {
    enum ErrorKind {
        case badRequest
        case serverError
        case invalidData
        case internalError
        case noConnection
    }
    
    let kind: ErrorKind
    
    init(_ kind: ErrorKind) {
        self.kind = kind
    }
    
    init(_ error: Error) {
        let error = error as NSError
        
        switch error.code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorInternationalRoamingOff, NSURLErrorDataNotAllowed, NSURLErrorNetworkConnectionLost:
            self.kind = .noConnection
        case NSURLErrorTimedOut, NSURLErrorCannotFindHost, NSURLErrorDNSLookupFailed, NSURLErrorCannotConnectToHost, NSURLErrorResourceUnavailable, NSURLErrorBackgroundSessionWasDisconnected, NSURLErrorCannotLoadFromNetwork:
            if NetworkManager.shared.isNetworkReachable {
                self.kind = .serverError
            } else {
                self.kind = .noConnection
            }
        default:
            self.kind = .internalError
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    let session: SessionManager
    
    /// Check this property for network reachability
    var isNetworkReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    private init() {
        // Create default url configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        session = Alamofire.SessionManager(configuration: configuration)
    }
    
    // MARK: - TMDB
    
    
    /// Querys TMDB movies for a given search string
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
                            onFailure(NetworkError(.internalError))
                            return
                        }
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                        let result = try decoder.decode(MovieResult.self, from: json)
                        onSuccess(result.movies)
                    } catch {
                        onFailure(NetworkError(.invalidData))
                    }
                case .failure(let error):
                    onFailure(NetworkError(error))
                }
        }
    }
    
}
