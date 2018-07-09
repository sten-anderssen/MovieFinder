//
//  MovieSearchDataController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 05.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

enum MovieSearchDataError: Error {
    case notFound
    case network(error: Error)
}

protocol MovieSearchDataControllerDelegate: class {
    func dataController(_ controller: MovieSearchDataController, didLoadData movies: [Movie])
    func dataController(_ controller: MovieSearchDataController, didFail error: MovieSearchDataError)
}


/// Data controller that handles downloading of data necessary for a view controller.
class MovieSearchDataController {
    
    // MARK: - Variables
    weak var delegate: MovieSearchDataControllerDelegate?
    
    /// Returns true if there are more pages to load from the API
    var canLoadMore = false

    private var searchMovieTask: DataRequest?
    private var currentPage: UInt = 1
    
    // MARK: - Networking
    
    /// Loads movies asynchronously for a given search string.
    ///
    /// - Parameter searchString: The string used for querying a movie database
    func loadMovieSearchResults(for searchString: String) {
        do {
            searchMovieTask = try NetworkManager.shared.searchMovies(for: searchString, page: 1, onSuccess: { movies in
                guard !movies.isEmpty else {
                    self.delegate?.dataController(self, didFail: .notFound)
                    return
                }
                self.delegate?.dataController(self, didLoadData: movies)
                self.canLoadMore = true
                try? PersistenceManager.shared.save(Query(value: searchString, date: Date()))
            }) { error in
                self.delegate?.dataController(self, didFail: .network(error: error))
            }
        } catch (let error) {
            self.delegate?.dataController(self, didFail: .network(error: error))
        }
    }
    
    /// Loads the next page if there is any for a search query.
    ///
    /// - Parameter searchString: The string used for querying a movie database
    func loadMore(for searchString: String) {
        if let searchMovieTask = searchMovieTask, !searchMovieTask.progress.isFinished {
            return
        }
        
        guard canLoadMore, !searchString.isEmpty else {
            return
        }
        
        do {
            searchMovieTask = try NetworkManager.shared.searchMovies(for: searchString, page: currentPage + 1, onSuccess: { movies in
                guard !movies.isEmpty else {
                    self.canLoadMore = false
                    return
                }
                self.delegate?.dataController(self, didLoadData: movies)
                self.currentPage += 1
            }) { error in
                self.canLoadMore = false
            }
        } catch {
            self.canLoadMore = false
        }
    }
}
