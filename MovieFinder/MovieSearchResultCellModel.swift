//
//  MovieSearchResultCellModel.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 03.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

struct MovieSearchResultCellModel {
    let title: String
    let releaseDate: Date
    let overview: String
    
    var releaseDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: releaseDate)
    }
}
