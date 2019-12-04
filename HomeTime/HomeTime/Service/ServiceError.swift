//
//  ServiceError.swift
//  HomeTime
//
//  Created by iOS Developer on 12/3/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation


/// JSON Error Exception
enum JSONError: Error {
    case serialization
}

extension JSONError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serialization:
            return NSLocalizedString("Serialization error", comment: "")
        }
    }
}

/// API Error Exception
enum ApiError: Error {
    case serverError
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverError:
            return NSLocalizedString("Something went wrong when requesting data", comment: "")
        }
    }
}
