//
//  SearchModel.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//


public struct SearchResponse: Decodable {
    public let resultCount: Int
    public let results: [Screenshots]
}

public struct Screenshots: Decodable {
    public let screenshotUrls: [String]
}
