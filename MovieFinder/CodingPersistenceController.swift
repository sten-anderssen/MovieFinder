//
//  CodingPersistenceController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 07.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

class CodingPersistenceController {
    
    private lazy var queryStore: [Query] = {
        guard let filePath = filePath,
              let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data else {
            return []
        }
        do {
            return try PropertyListDecoder().decode([Query].self, from: data)
        } catch {
            return []
        }
    }()

    private var filePath: String? {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url?.appendingPathComponent("Data").path
    }
}

// MARK: - PersistenceController

extension CodingPersistenceController: PersistenceController {

    func findAll<T>(_ type: T.Type) -> [T] {
        switch type {
        case is Query.Type:
            return queryStore as! [T]
        default:
            return []
        }
    }
    
    func insert<T>(_ element: T) throws {
        if let element = element as? Query {
            queryStore.append(element)
        } else {
            throw PersistenceError.systemError
        }
    }
    
    func remove<T: Storeable>(_ element: T) throws where T: Equatable {
        if let element = element as? Query {
            queryStore = queryStore.filter { $0 != element }
        } else {
            throw PersistenceError.systemError
        }
        
    }
    
    func save() throws {
        guard let filePath = filePath, !queryStore.isEmpty else {
            throw PersistenceError.saveError
        }
        
        let data = try PropertyListEncoder().encode(queryStore)
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
    }
}
