//
//  HomeViewModel.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import Foundation
import UIKit
import Kingfisher

protocol HomeViewDataSource {
    func zeroToHundredNumberOfItemsAt(section: Int) -> Int
    func zeroToHundredCellItemAt(indexPath: IndexPath) -> ImageCellProtocol
    func hundredToTwoHundredNumberOfItems(section: Int) -> Int
    func hundredToTwoHundredCellItemAt(indexPath: IndexPath) -> ImageCellProtocol
    func twoHundredAndHalfToFiveNumberOfItems(section: Int) -> Int
    func twoHundredAndHalfToFiveCellItemAt(indexPath: IndexPath) -> ImageCellProtocol
    func fiveHundredAndMoreNumberOfItems(section: Int) -> Int
    func fiveHundredAndMoreCellItemAt(indexPath: IndexPath) -> ImageCellProtocol
    func getSearchData(text: String)
}

protocol HomeViewEventSource {
    var reloadData: (() -> Void)? { get }
    var addEmptyView: (() -> Void)? { get }
    var removeEmptyView: (() -> Void)? { get }
}

protocol HomeViewProtocol: HomeViewDataSource, HomeViewEventSource {}

final class HomeViewModel: BaseViewModel, HomeViewProtocol {
    
    var reloadData: (() -> Void)?
    var addEmptyView: (() -> Void)?
    var removeEmptyView: (() -> Void)?
    
    private var screenshotUrls: [String] = []
    private var zeroToHundredKBArray: [ImageCellProtocol] = [] {
        didSet {
            reloadData?()
        }
    }
    private var hundredToTwoHundredKBArray: [ImageCellProtocol] = [] {
        didSet {
            reloadData?()
        }
    }
    
    private var twoHundredAndHalfToFiveKBArray: [ImageCellProtocol] = [] {
        didSet {
            reloadData?()
        }
    }
    
    private var fiveHundredAndMoreKBArray: [ImageCellProtocol] = [] {
        didSet {
            reloadData?()
        }
    }
    
    private var lastIndex = 0
    private var requestCount = 0 // for see how many request we have
    private var maxCount: Int {
        let concurrencyOperationCount = 3
        return screenshotUrls.count < concurrencyOperationCount ? screenshotUrls.count : concurrencyOperationCount
    }
    private let downloader = ImageDownloader.default
    
    private let dataProvider: DataProviderProtocol
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func zeroToHundredNumberOfItemsAt(section: Int) -> Int {
        return zeroToHundredKBArray.count
    }
    
    func zeroToHundredCellItemAt(indexPath: IndexPath) -> ImageCellProtocol {
        return zeroToHundredKBArray[indexPath.row]
    }
    
    func hundredToTwoHundredNumberOfItems(section: Int) -> Int {
        return hundredToTwoHundredKBArray.count
    }
    
    func hundredToTwoHundredCellItemAt(indexPath: IndexPath) -> ImageCellProtocol {
        return hundredToTwoHundredKBArray[indexPath.row]
    }
    
    func twoHundredAndHalfToFiveNumberOfItems(section: Int) -> Int {
        return twoHundredAndHalfToFiveKBArray.count
    }
    
    func twoHundredAndHalfToFiveCellItemAt(indexPath: IndexPath) -> ImageCellProtocol {
        return twoHundredAndHalfToFiveKBArray[indexPath.row]
    }
    
    func fiveHundredAndMoreNumberOfItems(section: Int) -> Int {
        return fiveHundredAndMoreKBArray.count
    }
    
    func fiveHundredAndMoreCellItemAt(indexPath: IndexPath) -> ImageCellProtocol {
        return fiveHundredAndMoreKBArray[indexPath.row]
    }
    
    func getSearchData(text: String) {
        clearData()
        self.downloader.cancelAll()
        let request = SearchRequest(term: text)
        dataProvider.getData(for: request) { [weak self] (result) in
            guard let self = self else { return }
            self.lastIndex = 0
            self.requestCount = 0
            switch result {
            case .success(let response):
                if response.resultCount > 0 {
                    self.clearData()
                    self.screenshotUrls = response.results.flatMap({ $0.screenshotUrls })
                    self.downloadImages()
                    self.removeEmptyView?()
                } else {
                    self.downloader.cancelAll()
                    self.clearData()
                    self.addEmptyView?()
                }
            case .failure:
                break
            }
        }
    }
    
    private func downloadImages() {
        for i in 0..<maxCount {
            downloadImage(index: i)
        }
    }
    
    private func downloadImage(index: Int) {
        if !self.screenshotUrls.isEmpty {
            guard let url = URL(string: self.screenshotUrls[index]) else {
                if self.screenshotUrls.indices.contains(self.lastIndex + 1) {
                    self.downloadImage(index: self.lastIndex + 1)
                    self.lastIndex += 1
                }
                return
            }
            self.requestCount += 1
            downloader.downloadImage(with: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    let size = value.image.getSize()
                    self.decideInsertToWhichSection(element: ImageCellModel(image: value.image), size: size)
                    if self.screenshotUrls.indices.contains(self.lastIndex + 1) {
                        self.downloadImage(index: self.lastIndex + 1)
                        self.lastIndex += 1
                    }
                    self.requestCount -= 1
                case .failure:
                    self.downloadImage(index: index)
                    self.requestCount -= 1
                }
                print("requestCount: \(self.requestCount)")
            }
        }
    }
    
    private func decideInsertToWhichSection(element: ImageCellProtocol, size: Double) {
        switch size {
        case 0..<1000:
            self.zeroToHundredKBArray.append(element)
        case 1000..<2500:
            hundredToTwoHundredKBArray.append(element)
        case 2500..<5000:
            twoHundredAndHalfToFiveKBArray.append(element)
        case 5000...Double.greatestFiniteMagnitude:
            fiveHundredAndMoreKBArray.append(element)
        default:
            return
        }
    }
    
    func clearData() {
        self.zeroToHundredKBArray.removeAll()
        self.hundredToTwoHundredKBArray.removeAll()
        self.twoHundredAndHalfToFiveKBArray.removeAll()
        self.fiveHundredAndMoreKBArray.removeAll()
        self.screenshotUrls.removeAll()
        self.reloadData?()
    }
}
