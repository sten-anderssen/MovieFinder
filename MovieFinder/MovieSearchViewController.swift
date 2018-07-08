//
//  SearchMovieViewController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var movieSearchComponentContainerView: UIView!
    
    // MARK: - Computed Variables
    
    private lazy var searchController: UISearchController? = {
        UISearchController(searchResultsController: nil)
    }()
    
    private lazy var movieSearchResultsComponent: MovieSearchResultsComponentViewController? = {
        let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "MovieSearchResultsComponentViewController") as? MovieSearchResultsComponentViewController
        controller?.delegate = self
        return controller
    }()
    
    private lazy var movieSearchQueriesComponent: MovieSearchQueriesComponentViewController? = {
        let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "MovieSearchQueriesComponentViewController") as? MovieSearchQueriesComponentViewController
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
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.barStyle = .black
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        
        setupMovieSearchResultsComponent()
        setupMovieSearchQueriesComponent()
    }
    
    // MARK: - Helper Methods
    
    // MARK: Loading data
    private func loadMovieResults(for query: String) {
        movieSearchResultsComponent?.model = nil
        dataController.loadMovieSearchResults(for: query)
    }
    
    private func loadMoreMovieResults(for query: String) {
        dataController.loadMore(for: query)
    }
    
    // MARK: Update Components
    private func showRecentMovieSearchQueries() {
        let queries = PersistenceManager.shared.fetchRecentSearchQueries()
        guard !queries.isEmpty else {
            return
        }
        movieSearchQueriesComponent?.model = MovieSearchQueriesComponentModel(with: queries)
        movieSearchResultsComponent?.model = nil
        movieSearchQueriesComponent?.view.isHidden = false
    }
    
    private func showMovieSearchResults(with movies: [Movie]) {
        if let data = movieSearchResultsComponent?.model?.data, !data.isEmpty {
            movieSearchResultsComponent?.model = MovieSearchResultComponentModel(with: data + movies)
        } else {
            movieSearchResultsComponent?.model = MovieSearchResultComponentModel(with: movies)
        }
        movieSearchQueriesComponent?.view.isHidden = true
        movieSearchResultsComponent?.view.isHidden = false
    }
    
    private func hideSearchComponents() {
        movieSearchQueriesComponent?.view.isHidden = true
        movieSearchResultsComponent?.view.isHidden = true
        dataController.canLoadMore = false
    }
    
    // MARK: Component Setup
    private func setupMovieSearchResultsComponent() {
        guard let movieSearchResultsComponent = movieSearchResultsComponent else {
            return
        }
        loadChildViewController(movieSearchResultsComponent, in: movieSearchComponentContainerView)
        movieSearchResultsComponent.view.isHidden = true
    }
    
    private func setupMovieSearchQueriesComponent() {
        guard let movieSearchQueriesComponent = movieSearchQueriesComponent else {
            return
        }
        loadChildViewController(movieSearchQueriesComponent, in: movieSearchComponentContainerView)
        movieSearchQueriesComponent.view.isHidden = true
    }
}

// MARK: - MovieSearchDataControllerDelegate

extension MovieSearchViewController: MovieSearchDataControllerDelegate {
    
    func dataController(_ controller: MovieSearchDataController, didLoadData movies: [Movie]) {
        showMovieSearchResults(with: movies)
    }
    
    func dataController(_ controller: MovieSearchDataController, didFail error: MovieSearchDataError) {
        switch error {
        case .notFound:
            let title = "Movie not found"
            let message = "Sorry, there is no movie with that name."
            let controller = UIAlertController.singleButtonAlert(with: title, message: message, buttonTitle: "Ok")
            present(controller, animated: true, completion: nil)
        case .network(let error):
            let controller = UIAlertController.alert(for: error)
            present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: - MovieSearchResultsComponentDelegate

extension MovieSearchViewController: MovieSearchResultsComponentDelegate {
    
    func componentDidDisplayLastCell(_ component: MovieSearchResultsComponentViewController) {
        guard let searchString = searchController?.searchBar.text else {
            return
        }
        loadMoreMovieResults(for: searchString)
    }
}

// MARK: - MovieSearchQueriesComponentDelegate

extension MovieSearchViewController: MovieSearchQueriesComponentDelegate {
    
    func component(_ component: MovieSearchQueriesComponentViewController, didSelect query: String) {
        searchController?.searchBar.text = query
        searchController?.searchBar.resignFirstResponder()
        loadMovieResults(for: query)
    }
}

// MARK: - UISearchBarDelegate

extension MovieSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.text, searchString.isEmpty else {
            return
        }
        showRecentMovieSearchQueries()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.text else {
            return
        }
        loadMovieResults(for: searchString)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchComponents()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            showRecentMovieSearchQueries()
        }
    }
}
