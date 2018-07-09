//
//  MovieSearchComponentModel.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

/// View model that holds movie data that is displayed in a collection component controller.
class MovieSearchResultComponentModel: BaseCollectionComponentModel {

    override func convertData() {
        super.convertData()
        guard let data = data as? [Movie] else {
            return
        }
        let rowData = data.map { movie in
            return MovieSearchResultCellModel(title: movie.title, releaseDate: movie.releaseDate, overview: movie.overview, posterPath: movie.posterPath)
        }
        convertedData?.append(BaseSectionDataModel(with: rowData))
    }
}
