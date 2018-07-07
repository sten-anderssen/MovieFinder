//
//  MovieSearchQueriesComponentViewController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 07.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

protocol MovieSearchQueriesComponentDelegate: class {
    func component(_ component: MovieSearchQueriesComponentViewController, didSelect query: String)
}

class MovieSearchQueriesComponentViewController: BaseTableComponentViewController {
    
    // MARK: - Variables
    
    weak var delegate: MovieSearchQueriesComponentDelegate?
    
    // MARK: - BaseTableComponentProtocol
    
    override func cellIdentifier(for indexPath: IndexPath) -> String {
        return "MovieSearchQueriesViewCell"
    }
}

extension MovieSearchQueriesComponentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let model = model as? MovieSearchQueriesComponentModel, let data = model.data as? [String?], let query = data[indexPath.row] else {
            return
        }
        
        delegate?.component(self, didSelect: query)
    }
}
