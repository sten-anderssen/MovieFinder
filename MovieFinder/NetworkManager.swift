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
    func loadMovies(for searchString: String, page: UInt, onSucces: @escaping (String) -> Void, onFailure: @escaping (Error) -> Void) throws -> DataRequest {
        guard let url = try TMDBUrlBuilder.createSearchMovieUrl(for: searchString, page: page) else {
            throw NetworkError(.badRequest)
        }
        
        return session.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data, let jsonString = String(data: data, encoding: String.Encoding.utf8) else {
                    onFailure(NetworkError(.invalidData))
                    return
                }
                onSucces(jsonString)
            case .failure(let error):
                onFailure(NetworkError(error))
            }
        }
    }
    
}
