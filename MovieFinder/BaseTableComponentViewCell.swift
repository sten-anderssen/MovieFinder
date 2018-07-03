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
