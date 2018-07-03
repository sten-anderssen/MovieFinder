//
//  SearchMovieViewController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

class SearchMovieViewController: UIViewController, BaseComponentProtocol {
    
    @IBOutlet private weak var movieSearchResultsComponentContainer: UIView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var movieSearchResultsComponent: MovieSearchResultsComponentViewController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MovieSearchResultsComponentViewController") as? MovieSearchResultsComponentViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.barStyle = .black
        
        definesPresentationContext = true
        
        refresh()
    }
    
    func refresh() {
        loadMovieSearchResultsComponent()
    }
    
    // MARK: - Helper Methods
    private func loadMovieSearchResultsComponent() {
        guard let movieSearchResultsComponent = movieSearchResultsComponent else {
            return
        }
        loadChildViewController(movieSearchResultsComponent, in: movieSearchResultsComponentContainer, animated: true)

//        movieSearchResultsComponent.model = MovieSearchResultComponentModel(with: data)
    }
}

extension SearchMovieViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
