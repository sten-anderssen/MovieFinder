//
//  BaseCollectionComponentViewCell.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

protocol BaseTableComponentViewCellProtocol {
    func updateUI()
}

/// Base view cell class for any cell used to display data in a table view component.
class BaseTableComponentViewCell: UITableViewCell, BaseTableComponentViewCellProtocol {
    
    // MARK: - Model
    
    var data: Any? {
        didSet {
            self.updateUI()
        }
    }
    
    // MARK: - Framework

    /// Refresh the UI. Will be called on data change.
    func updateUI() {
        // may be overriden in subclass
    }
    
}
