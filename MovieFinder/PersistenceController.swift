//
//  PersistenceController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 08.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

enum PersistenceError: Error {
    case systemError
    case saveError
}

/// Protocol to define a persistent controller.
protocol PersistenceController {

    func findAll<T>(_ type:T.Type) -> [T]
    func insert(_ element: Storeable) throws
    func remove<T: Storeable>(_ element: T) throws where T: Equatable
    func save() throws
}
