//
//  SearchMovieViewController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit
import Alamofire

class MovieSearchViewController: UIViewController, BaseComponentProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var movieSearchResultsComponentContainer: UIView!
    
    // MARK: - Variables
    private var model: SearchMovieModel? {
        didSet {
            refresh()
        }
    }
    
    private lazy var searchController: UISearchController? = {
        UISearchController(searchResultsController: movieSearchResultsComponent)
    }()
    private lazy var movieSearchResultsComponent: MovieSearchResultsComponentViewController? = {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "MovieSearchResultsComponentViewController") as? MovieSearchResultsComponentViewController
    }()
    private var searchMovieTask: DataRequest?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let searchController = searchController else {
            return
        }
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.barStyle = .black
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
    }
    
    func refresh() {
        guard let model = model else {
            return
        }
        
        if !model.data.isEmpty {
            refreshMovieSearchResultsComponent()
        }
    }
    
    // MARK: - Helper Methods
    func loadSearchResults(for searchString: String) {
        do {
            searchMovieTask = try NetworkManager.shared.searchMovies(for: searchString, page: 1, onSuccess: { movies in
                self.model = SearchMovieModel(data: movies)
            }) { error in
            
            }
        } catch (let error) {
            
        }
    }
    
    private func refreshMovieSearchResultsComponent() {
        guard let movieSearchResultsComponent = movieSearchResultsComponent else {
            return
        }
        movieSearchResultsComponent.model = createMovieSearchResultComponentModel()
    }
    
    private func createMovieSearchResultComponentModel() -> MovieSearchResultComponentModel? {
        guard let model = model else {
            return nil
        }
        return MovieSearchResultComponentModel(with: model.convertedData)
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.text, !searchString.isEmpty else {
            // TODO: Show error for empty search string
            return
        }
        loadSearchResults(for: searchString)
    }
}
