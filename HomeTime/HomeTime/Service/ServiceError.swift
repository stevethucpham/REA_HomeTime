//
//  ServiceError.swift
//  HomeTime
//
//  Created by iOS Developer on 12/3/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

/// API Error Exception
public enum ApiError: Error {
    case noDataError
    case serverError
    case serialization
    case noToken
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serverError:
            return NSLocalizedString("Something went wrong when requesting data", comment: "")
        case .serialization:
            return NSLocalizedString("Serialization error", comment: "")
        case .noToken:
            return NSLocalizedString("Cannot get token", comment: "")
        case .noDataError:
            return NSLocalizedString("No Data", comment: "")
        }
        
    }
}
