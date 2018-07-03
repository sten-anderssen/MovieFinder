//
//  SearchMovieModel.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

struct SearchMovieModel {
    
    let data: [Movie]
    
    var convertedData: [MovieSearchResultCellModel] {
        return data.map { movie in
            return MovieSearchResultCellModel(title: movie.title, releaseDate: movie.releaseDate, overview: movie.overview, posterPath: movie.posterPath)
        }
    }
}
