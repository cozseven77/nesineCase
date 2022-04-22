//
//  DataProviderProtocol.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import Alamofire

public typealias DataProviderResult<T: Decodable> = ((Result<T, Error>) -> Void)

public protocol DataProviderProtocol {
    
    var baseUrl: String { get }
    
    func getData<T: RequestProtocol>(for request: T,
                                     result: DataProviderResult<T.ResponseType>?)
    
}
