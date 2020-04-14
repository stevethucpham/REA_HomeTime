//
//  TramTableService.swift
//  HomeTime
//
//  Created by iOS Developer on 12/8/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import RxSwift


protocol TramTableServiceType {
    
    var session: URLSession { get }
    
    /// This function requests the API and return Data response
    /// - Parameter url: API URL
    func requestDataResponse(from url: URL) -> Single<Data>
    
    func fetchApiToken() -> Single<String?>
    
    func loadTramDataUsing(stopId: String) -> Single<[TramData]?>
}

extension TramTableServiceType {
    
    func requestDataResponse(from url: URL) -> Single<Data> {
        return Single<Data>.create { single in
            let task = self.session.dataTask(with: url) { data, response , error in
                
                if let error = error {
                    single(.error(error))
                }
                
                guard let dataObject = data else
                {
                    single(.error(error ?? ApiError.serverError))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    single(.error(ApiError.serverError))
                    return
                }
                single(.success(dataObject))
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

class TramTableService: TramTableServiceType {
    
    let session: URLSession
    var token: String?
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    init(session: URLSession, token: String? = nil) {
           self.session = session
           self.token = token
    }
    
    func fetchApiToken() -> Single<String?> {
        let url = URL(string: Constants.Service.tokenUrl)!
        
        if let token = token {
            return Single.just(token)
        } else {
            return self.requestDataResponse(from: url)
                .map(TramResponseObject<Token>.self)
                .map { (result) -> String? in
                    return result.responseObject.first?.deviceToken
            }
            
        }
    }
    
    func loadTramDataUsing(stopId: String) -> Single<[TramData]?> {
        fetchApiToken().flatMap { (token) -> Single<[TramData]?> in
            guard let token = token else {
                return Single.error(ApiError.noToken)
            }
            let url = URL(string: self.urlFor(stopId: stopId, token: token))!
            return self.requestDataResponse(from: url)
                .map(TramResponseObject<TramData>.self)
                .map { (result) -> [TramData]? in
                    return result.responseObject
            }
        }
    }
    
    /// This function returns a *url string* to aid to fetch tram timetable data.
    /// - Parameter stopId: stopId
    /// - Parameter token: token
    /// - returns: complete url to retrieve the tram timetable data
    func urlFor(stopId: String, token: String) -> String {
        return Constants.Service.tramUrl.replacingOccurrences(of: "{STOP_ID}", with: stopId).replacingOccurrences(of: "{TOKEN}", with: token)
    }

}

