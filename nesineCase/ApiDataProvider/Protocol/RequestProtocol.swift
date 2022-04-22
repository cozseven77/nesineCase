//
//  RequestProtocol.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import Alamofire

public protocol RequestProtocol {
    
    associatedtype ResponseType: Decodable
            
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var encoding: ParameterEncoding { get }
    
}

public extension RequestProtocol {
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
}
