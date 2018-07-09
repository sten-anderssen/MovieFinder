//
//  BaseTableComponentViewController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import UIKit

/// Base class for a table view component controller.
class BaseTableComponentViewController: UIViewController, BaseComponentProtocol, UITableViewDataSource {
    
    // MARK: - Model
    
    var model: BaseCollectionComponentModel? {
        didSet {
            refresh()
        }
    }
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.dataSource = self
        registerCellIdentifiers()
    }
    
    /// Additional table view setup method.
    func setupTableView() {
        // may be overriden in subclass
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.numberOfItemsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier(for: indexPath), for: indexPath)
        if let cell = cell as? BaseTableComponentViewCell, let data = model?.getCellData(forIndexPath: indexPath) {
            cell.data = data
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model?.getTitleForHeader(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return model?.getTitleForFooter(inSection: section)
    }
    
    // MARK: - Framework

     /// Registers all cell identifiers for the table view.
    func registerCellIdentifiers() {
        if let numberOfSections = model?.numberOfSections() {
            var cellIdentifiers = Set<String>()
            
            for sectionIndex in 0..<numberOfSections {
                if let numberOfRows = model?.numberOfItemsInSection(section: sectionIndex) {
                    for rowIndex in 0..<numberOfRows {
                        let newCellIdentifier = cellIdentifier(for: IndexPath(row: rowIndex, section: sectionIndex))
                        cellIdentifiers.insert(newCellIdentifier)
                    }
                }
            }
            
            for currentCellIdentifier in cellIdentifiers {
                tableView.register(UINib(nibName: currentCellIdentifier, bundle: nil), forCellReuseIdentifier: currentCellIdentifier)
            }
        }
    }
    
    /// Returns a cell identifier for a given index path. Must be overriden in subclass.
    ///
    /// - Parameter indexPath: IndexPath of the cell
    /// - Returns: The cell identifier as String.
    func cellIdentifier(for indexPath: IndexPath) -> String {
        assert(false, "This method must be overriden by the subclass")
        return ""
    }

    /// Refresh the table view. Will be called on data change.
    func refresh() {
        if tableView?.dequeueReusableCell(withIdentifier: cellIdentifier(for: IndexPath(row: 0, section: 0))) == nil {
            registerCellIdentifiers()
        }
        tableView?.reloadData()
    }
}
