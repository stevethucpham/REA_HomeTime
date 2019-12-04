//
//  ServiceResult.swift
//  HomeTime
//
//  Created by iOS Developer on 12/3/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

// MARK: Network Result
enum ServiceResult<T> {
    case success(T)
    case failure(Error?)
}
