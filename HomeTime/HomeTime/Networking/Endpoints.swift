//
//  Endpoints.swift
//  HomeTime
//
//  Created by Thuc Pham on 16/8/20.
//  Copyright © 2020 REA. All rights reserved.
//

import Foundation

public protocol RelativeEndpoint {
    var query: [String: String]? { get }
    var relativePath: String { get }
}

public extension RelativeEndpoint {
    var query: [String: String]? {
        return nil
    }
    
    func request(base: URL) -> URLRequest {
        return URLRequest(url: base.appending(self))
    }
}


// MARK: TramEndpoints
enum TramEndpoint: RelativeEndpoint {
    case deviceToken
    
    case predictedRoutes(stopNumer: String, token: String)
    
    var query: [String : String]? {
        switch self {
        case .deviceToken:
            return ["aid": "TTIOSJSON",
                    "devInfo":"HomeTimeiOS"]
        case .predictedRoutes(_, let token):
            return ["aid": "TTIOSJSON",
                    "cid": "2",
                    "tkn": token]
        }
    }
    
    var relativePath: String {
        switch self {
        case .deviceToken:
            return "TramTracker/RestService/GetDeviceToken/"
        case .predictedRoutes(let stopNumber, _):
            return "TramTracker/RestService/GetNextPredictedRoutesCollection/\(stopNumber)/78/false/"
        }
    }
    
}


// MARK: URL Extension
public extension URL {
    
    func appending(_ relative: RelativeEndpoint) -> URL {
        let url = appendingPathComponent(relative.relativePath)
        if let query = relative.query {
            return url.setQueryParameters(query)
        }
        return url
    }
    
    func setQueryParameters(_ parameters: [String: String?]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        guard let url = components.url else { return self }
        return url
    }
    
}


