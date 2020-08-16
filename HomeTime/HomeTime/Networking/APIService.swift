//
//  APIService.swift
//  HomeTime
//
//  Created by Thuc Pham on 16/8/20.
//  Copyright © 2020 REA. All rights reserved.
//

import Foundation
import RxSwift

struct APIService {
    let baseURL: URL
    let network: NetworkService
    
    init(baseURL: URL, network: NetworkService) {
        self.baseURL = baseURL
        self.network = network
    }
    
    func get<T:Decodable>(endPoints: TramEndpoint) -> Single<T> {
        let request = endPoints.request(base: baseURL)
        return network.singleDataTask(with: request)
    }
}
