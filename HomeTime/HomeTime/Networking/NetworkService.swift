//
//  NetworkService.swift
//  HomeTime
//
//  Created by Thuc Pham on 15/8/20.
//  Copyright © 2020 REA. All rights reserved.
//

import Foundation
import RxSwift

public protocol NetworkService {
    
    func singleDataTask<T: Decodable>(with request: URLRequest) -> Single<T>
}

// MARK: Network Service Implmentation
struct NetworkServiceImplementation: NetworkService {
    
    private let networkSession: URLSession
    
    static var defaultSession: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }
    
    init(session: URLSession = NetworkServiceImplementation.defaultSession) {
        self.networkSession = session
    }
    
    func singleDataTask<T>(with request: URLRequest) -> Single<T> where T : Decodable {
        return Single<T>.create { single in
            let task = self.performNetworkSession(for: request, onSuccess: { result in
                NetworkServiceImplementation.decode(result: result, single: single)
            }, onError: { error in
                single(.error(error))
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        .observeOn(MainScheduler.instance)
        .debug(request.url?.absoluteString)
    }
    
    
    /// Deserialize the data response to JSON
    /// - Parameters:
    ///   - result: Data response
    ///   - single: The single event
    private static func decode<T: Decodable>(result: Data?, single:(RxSwift.SingleEvent<T>) -> Void) {
        do {
            guard let jsonData = result else { throw ApiError.noDataError }
            let decodedData: T = try JSONDecoder().decode(T.self, from: jsonData)
            single(.success(decodedData))
        } catch {
            single(.error(error))
        }
    }
    
    private func performNetworkSession(for request: URLRequest,
                                       onSuccess: @escaping(Data?) -> Void,
                                       onError: @escaping(Error) -> Void) -> URLSessionTask {
        let task = networkSession.dataTask(with: request) { data, response, error in
            do {
                if let error = error as? URLError {
                    throw error
                }
                guard let response = response as? HTTPURLResponse else {
                    throw ApiError.serverError
                }
                guard (200..<300).contains(response.statusCode) else {
                    throw ApiError.noDataError
                }
                onSuccess(data)
            } catch {
                onError(error)
            }
        }
        return task
    }
}
