//
//  MovieSearchResultsComponentViewController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

protocol MovieSearchResultsComponentDelegate: class {
    func componentDidDisplayLastCell(_ component: MovieSearchResultsComponentViewController)
}

class MovieSearchResultsComponentViewController: BaseTableComponentViewController {
    
    // MARK: - Variables
    
    weak var delegate: MovieSearchResultsComponentDelegate?
    
    // MARK: - BaseTableComponentProtocol
    
    override func cellIdentifier(forIndexPath: IndexPath) -> String {
        return "MovieSearchResultViewCell"
    }
}

extension MovieSearchResultsComponentViewController: UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let section = model?.convertedData?.first, section.rows.count - 1 == indexPath.row else {
            return
        }
        
        delegate?.componentDidDisplayLastCell(self)
    }
}
