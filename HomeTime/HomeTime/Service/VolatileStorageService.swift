//
//  VolatileStorageService.swift
//  HomeTime
//
//  Created by Thuc Pham on 16/8/20.
//  Copyright © 2020 REA. All rights reserved.
//

import Foundation


/// This class is to store session value
public final class VolatileStorageService {
    
    /// Data values dictionary
    private(set) var dataValues: [String: String]
    // The queue to prevent any udpates that could happen while saving the data
    let queue = DispatchQueue(label: "Storage")
    
    
    public init(dataValues: [String: String] = [:]) {
        self.dataValues = dataValues
    }
    
    /// Store data to the memory in a sessions
    /// - Parameters:
    ///   - data: value
    ///   - key: key
    public func storeData( _ data: String?, for key: String) {
        queue.sync {
            if data == nil {
                dataValues.removeValue(forKey: key)
            } else {
                dataValues[key] = data
            }
        }
    }
    
    /// Get raw data from the key
    /// - Parameter key: key of the saved value
    /// - Returns: string value if key existed, nil otherwise
    public func rawData(for key: String) -> String? {
        return queue.sync {
            return dataValues[key]
        }
    }
    
    /// Remove all data in session
    public func eraseAll() {
        queue.sync {
            dataValues = [:]
        }
    }
}
