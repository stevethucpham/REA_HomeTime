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
    func request<T: Decodable> (from url: URLRequest, completionHandler: @escaping (ServiceResult<T>) -> Void)
}

// MARK: Extension Tram Service Type
extension TramServiceType {
    /// This API request the API and decode the JSON Response
    /// - Parameters:
    ///   - url: API URL
    ///   - completionHandler: the completion handler which returns a decodable type if success, otherwise returns error.
    func request<T: Decodable> (from url: URLRequest, completionHandler: @escaping (ServiceResult<T>) -> Void) {
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
                completionHandler(.failure(JSONError.serialization))
            }
            
        }
        task.resume()
    }
}


// MARK: Tram Service Client
class TramService: TramServiceType {
    
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    
    /// This function returns a *token* within a completion handler
    /// - Parameter completion: completion handler returns *ServiceResult* with success and failure case
    func fetchApiToken(completion: @escaping (ServiceResult<String?>) -> Void) {
        let url = URL(string: Constants.Service.tokenUrl)!
        request(from: URLRequest(url: url)) { (result: ServiceResult<TramResponseObject<String>>) in
            switch result {
            case .success(let response):
                completion(ServiceResult.success(response.responseObject?.first))
                break
            case .failure(let error):
                completion(ServiceResult.failure(error))
                break
            }
        }
    }
    
    /// This function returns an array of *TramData* within a completion handler
    /// - Parameters:
    ///   - stopId: the tram stop id
    ///   - completion: completion handler returns *ServiceResult* with success and failure case
    func loadTramDataUsing(stopId: String, completion: @escaping (ServiceResult<[TramData]?>) -> Void) {
        let url = URL(string: Constants.Service.tramUrl)!
        request(from: URLRequest(url: url)) { (result: ServiceResult<TramResponseObject<TramData>>) in
            switch result {
            case .success(let response):
                completion(ServiceResult.success(response.responseObject))
                break
            case .failure(let error):
                completion(ServiceResult.failure(error))
                break
            }
        }
        
    }
}
