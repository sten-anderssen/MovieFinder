//
//  SearchMovieViewController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController, BaseComponentProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var movieSearchResultsComponentContainer: UIView!
    
    // MARK: - Variables
    private var model: SearchMovieModel? {
        didSet {
            refresh()
        }
    }
    
    // MARK: - Computed Variables
    
    private lazy var searchController: UISearchController? = {
        UISearchController(searchResultsController: movieSearchResultsComponent)
    }()
    
    private lazy var movieSearchResultsComponent: MovieSearchResultsComponentViewController? = {
        let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "MovieSearchResultsComponentViewController") as? MovieSearchResultsComponentViewController
        controller?.delegate = self
        return controller
    }()
    
    private lazy var dataController: MovieSearchDataController = {
        let controller = MovieSearchDataController()
        controller.delegate = self
        return controller
    }()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let searchController = searchController else {
            return
        }
        
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
    
    func resetMovieSearchResults() {
        dataController.canLoadMore = false
        model = SearchMovieModel(data: [])
        resetMovieSearchResultsComponent()
    }
    
    // MARK: - MovieSearchResultComponent
    
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
    
    private func resetMovieSearchResultsComponent() {
        guard let movieSearchResultsComponent = movieSearchResultsComponent else {
            return
        }
        movieSearchResultsComponent.model = nil
    }
}

// MARK: - MovieSearchDataControllerDelegate

extension MovieSearchViewController: MovieSearchDataControllerDelegate {
    
    func dataController(_ controller: MovieSearchDataController, didLoadData movies: [Movie]) {
        if let data = model?.data, !data.isEmpty {
            model = SearchMovieModel(data: data + movies)
        } else {
            model = SearchMovieModel(data: movies)
        }
    }
}

// MARK: - MovieSearchResultsComponentDelegate

extension MovieSearchViewController: MovieSearchResultsComponentDelegate {
    
    func componentDidDisplayLastCell(_ component: MovieSearchResultsComponentViewController) {
        guard let searchString = searchController?.searchBar.text else {
            return
        }
        dataController.loadMore(for: searchString)
    }
}

// MARK: - UISearchBarDelegate

extension MovieSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.text else {
            return
        }
        dataController.loadMovieSearchResults(for: searchString)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetMovieSearchResults()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resetMovieSearchResults()
        }
    }
}
