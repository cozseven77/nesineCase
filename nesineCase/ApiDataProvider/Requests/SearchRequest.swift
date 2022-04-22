//
//  SearchRequest.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import Alamofire

public struct SearchRequest: RequestProtocol {

    public typealias ResponseType = SearchResponse

    public var path: String
    public var method: HTTPMethod = .get
    public var parameters: Parameters = [:]
    
    public init(term: String) {
        path = "term=" + term + "&media=software"
    }
}
