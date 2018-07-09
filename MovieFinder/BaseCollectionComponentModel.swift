//
//  BaseCollectionComponentModel.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 02.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

/// View model that holds data that can be used to display cells in a collection component.
class BaseCollectionComponentModel {
    
    var data: [Any?]?
    var convertedData: [BaseSectionDataModel]?
    
    init(with data: [Any?]) {
        self.data = data
        self.convertData()
    }
    
    // MARK: - DataSource Protocol
    
    func numberOfSections() -> Int {
        return convertedData?.count ?? 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard let convertedData = convertedData else {
            return 0
        }
        
        // section index value is 0-based
        if convertedData.count > section {
            let sectionData = convertedData[section]
            return sectionData.rows.count
        }
        
        return 0
    }
  
    /// Returns a data object for the cell at a given index path.
    ///
    /// - Parameter indexPath: IndexPath of the cell
    /// - Returns: A data object
    func getCellData(forIndexPath indexPath: IndexPath) -> Any? {
        guard let convertedData = convertedData else {
            return nil
        }
        
        if indexPath.section >= convertedData.count {
            return nil
        }
        
        let sectionData = convertedData[indexPath.section]
        
        if indexPath.row >= sectionData.rows.count {
            return nil
        }
        
        return sectionData.rows[indexPath.row]
    }
    
    /// Returns the title text of a section as String.
    ///
    /// - Parameter section: Index of the section
    /// - Returns: Title text of the section
    func getTitleForHeader(inSection section: Int) -> String? {
        guard let convertedData = convertedData else {
            return nil
        }
        if convertedData.count > section {
            let sectionData = convertedData[section]
            return sectionData.sectionTitle
        }
        return nil
    }

    /// Returns the footer text of a section as String.
    ///
    /// - Parameter section: Index of the section
    /// - Returns: Footer text of the section
    func getTitleForFooter(inSection section: Int) -> String? {
        guard let convertedData = convertedData else {
            return nil
        }
        if convertedData.count > section {
            let sectionData = convertedData[section]
            return sectionData.sectionFooterTitle
        }
        return nil
    }

    /// Converts the data model to BaseSectionDataModel array, which can be displayed by the collection view.
    func convertData() {
        // override in subclass, until then:
        convertedData = []
    }
}
