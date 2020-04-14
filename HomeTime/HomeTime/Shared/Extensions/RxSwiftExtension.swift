//
//  RxSwiftExtension.swift
//  HomeTime
//
//  Created by iOS Developer on 12/9/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequenceType where Trait == SingleTrait, Element == Data {
    func map<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> PrimitiveSequence<Trait, T> where T: Decodable {
        return self.map { data -> T in
            let decoder = decoder ?? JSONDecoder()
            return try decoder.decode(type, from: data)
        }
    }
}
