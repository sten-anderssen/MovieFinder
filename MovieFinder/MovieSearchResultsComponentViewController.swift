//
//  MovieSearchResultsComponentViewController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

class MovieSearchResultsComponentViewController: BaseTableComponentViewController {
    
    // MARK: - BaseComponentProtocol
    
    override func refresh() {
        if tableView.dequeueReusableCell(withIdentifier: cellIdentifier(forIndexPath: IndexPath(row: 0, section: 0))) == nil {
            registerCellIdentifiers()
        }
        super.refresh()
    }
    
    // MARK: - BaseTableComponentProtocol
    
    override func cellIdentifier(forIndexPath: IndexPath) -> String {
        return "MovieSearchResultViewCell"
    }
}
