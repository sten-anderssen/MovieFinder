//
//  MovieSearchQueryViewCell.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 06.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

/// View cell that displays a search query in a table view.
class MovieSearchQueriesViewCell: BaseTableComponentViewCell {
    
    @IBOutlet private weak var queryLabel: UILabel!
    
    override func updateUI() {
        guard let model = data as? MovieSearchQueriesCellModel else {
            return
        }
        
        queryLabel.text = model.query
    }
}
