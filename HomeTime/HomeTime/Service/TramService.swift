//
//  TramService.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

// MARK: Tram Service Type
protocol TramServiceType {
    var session: URLSession { get }
    func fetchApiToken(completion: @escaping (_ result: ServiceResult<String?>) -> Void)
    func loadTramDataUsing(stopId: String, completion: @escaping (_ result: ServiceResult<[TramData]?>) -> Void)
    func request<T: Decodable> (from url: URL, completionHandler: @escaping (ServiceResult<T>) -> Void)
}

// MARK: Extension Tram Service Type
extension TramServiceType {
    /// This API request the API and decode the JSON Response
    /// - Parameters:
    ///   - url: API URL
    ///   - completionHandler: the completion handler which returns a decodable type if success, otherwise returns error.
    func request<T: Decodable> (from url: URL, completionHandler: @escaping (ServiceResult<T>) -> Void) {
        let task = session.dataTask(with: url) { data, response , error in
            
            guard let dataObject = data else { completionHandler(.failure(error)); return  }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(ApiError.serverError))
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(T.self, from: dataObject)
                debugPrint(jsonResponse)
                completionHandler(.success(jsonResponse))
            } catch {
                completionHandler(.failure(ApiError.serialization))
            }
            
        }
        task.resume()
    }
}


// MARK: Tram Service Client
class TramService: TramServiceType {
    
    let session: URLSession
    var token: String?
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    
    /// This function returns a *token* within a completion handler
    /// - Parameter completion: completion handler returns *ServiceResult* with success and failure case
    func fetchApiToken(completion: @escaping (ServiceResult<String?>) -> Void) {
        let url = URL(string: Constants.Service.tokenUrl)!
        if let token = token {
            completion(ServiceResult.success(token))
        } else {
            request(from: url) { (result: ServiceResult<TramResponseObject<Token>>) in
                switch result {
                case .success(let response):
                    self.token = response.responseObject.first?.deviceToken
                    completion(ServiceResult.success(response.responseObject.first?.deviceToken))
                    break
                case .failure(let error):
                    completion(ServiceResult.failure(error))
                    break
                }
            }
        }
    }
    
    /// This function returns an array of *TramData* within a completion handler
    /// - Parameters:
    ///   - stopId: the tram stop id
    ///   - completion: completion handler returns *ServiceResult* with success and failure case
    func loadTramDataUsing(stopId: String, completion: @escaping (ServiceResult<[TramData]?>) -> Void) {
        fetchApiToken { (result) in
            switch result {
            case .success(let token):
                guard let token = token else {
                    completion(ServiceResult.failure(ApiError.noToken))
                    return
                }
                let url = URL(string: self.urlFor(stopId: stopId, token: token))!
                self.request(from: url) { (result: ServiceResult<TramResponseObject<TramData>>) in
                    switch result {
                    case .success(let response):
                        completion(ServiceResult.success(response.responseObject))
                        break
                    case .failure(let error):
                        completion(ServiceResult.failure(error))
                        break
                    }
                }
                break
            case .failure(let error):
                completion(ServiceResult.failure(error))
                break
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
