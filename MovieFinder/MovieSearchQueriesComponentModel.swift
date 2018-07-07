//
//  MovieSearchQueryComponentModel.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 07.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

class MovieSearchQueriesComponentModel: BaseCollectionComponentModel {
    
    override func convertData() {
        super.convertData()
        guard let data = data as? [String] else {
            return
        }
        let rowData = data.map { query in
            return MovieSearchQueriesCellModel(query: query)
        }
        convertedData?.append(BaseSectionDataModel(with: rowData))
    }
}
