//
//  MovieSearchDataController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 05.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation
import Alamofire

protocol MovieSearchDataControllerDelegate: class {
    func dataController(_ controller: MovieSearchDataController, didLoadData movies: [Movie])
}

class MovieSearchDataController {
    
    // MARK: - Variables
    weak var delegate: MovieSearchDataControllerDelegate?
    
    var canLoadMore = false

    private var searchMovieTask: DataRequest?
    private var currentPage: UInt = 1
    
    // MARK: - Networking
    
    func loadMovieSearchResults(for searchString: String) {
        do {
            searchMovieTask = try NetworkManager.shared.searchMovies(for: searchString, page: 1, onSuccess: { movies in
                self.delegate?.dataController(self, didLoadData: movies)
                self.canLoadMore = true
            }) { error in
                
            }
        } catch {
            
        }
    }
    
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
