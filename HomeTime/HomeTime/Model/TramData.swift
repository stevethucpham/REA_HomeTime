//
//  TramData.swift
//  HomeTime
//
//  Created by iOS Developer on 12/3/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

struct TramResponseObject<T: Decodable>: Decodable {
    let responseObject: [T]
}

struct TramData: Decodable {
    /// The destination of the tram
    var destination: String?
    /// Predicted arrival date time of the tram
    var predictedArrivalDateTime: String?
    /// The route number of the tram
    var routeNo: String?
    
    enum CodingKeys: String, CodingKey {
        case destination = "Destination"
        case predictedArrivalDateTime = "PredictedArrivalDateTime"
        case routeNo = "RouteNo"
    }
}

struct Token: Decodable {
    let deviceToken: String?
    enum CodingKeys: String, CodingKey {
        case deviceToken = "DeviceToken"
    }
}
