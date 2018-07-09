//
//  MovieSearchQueryComponentModel.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 07.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

/// View model that holds search query data that is displayed in a collection component controller.
class MovieSearchQueriesComponentModel: BaseCollectionComponentModel {
    
    override func convertData() {
        super.convertData()
        guard let data = data as? [Query] else {
            return
        }
        let rowData = data.map { query in
            return MovieSearchQueriesCellModel(query: query.value)
        }
        convertedData?.append(BaseSectionDataModel(with: rowData))
    }
}
