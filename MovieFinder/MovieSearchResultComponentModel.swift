//
//  MovieSearchComponentModel.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

class MovieSearchResultComponentModel: BaseCollectionComponentModel {
    
    override func convertData() {
        super.convertData()
        guard let rowData = data as? [MovieSearchResultCellModel] else {
            return
        }
        
        convertedData?.append(BaseSectionDataModel(with: rowData))
    }
}
