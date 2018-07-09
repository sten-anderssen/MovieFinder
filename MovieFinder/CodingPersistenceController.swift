//
//  CodingPersistenceController.swift
//  MovieFinder
//
//  Created by Sten Anderßen on 07.07.18.
//  Copyright © 2018 Sten Anderßen. All rights reserved.
//

import Foundation

/// Persistent controller that stores data in a file on the device.
class CodingPersistenceController {
    
    private lazy var queryStore: [Query] = {
        guard let filePath = queryStoreFilePath,
              let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data else {
            return []
        }
        do {
            return try PropertyListDecoder().decode([Query].self, from: data)
        } catch {
            return []
        }
    }()
    
    private lazy var queryStoreFilePath: String? = {
        guard let fileUrl = fileUrl else {
            return nil
        }
        return fileUrl.appendingPathComponent("Query").path
    }()

    private lazy var fileUrl: URL? = {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url
    }()
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
        guard let filePath = queryStoreFilePath, !queryStore.isEmpty else {
            throw PersistenceError.saveError
        }
        
        let data = try PropertyListEncoder().encode(queryStore)
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
    }
}
