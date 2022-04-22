//
//  HomeDetailViewModel.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import Foundation
import UIKit
import Kingfisher

protocol HomeDetailViewDataSource {
    var image: UIImage { get }
}

protocol HomeDetailViewProtocol: HomeDetailViewDataSource {}

final class HomeDetailViewModel: BaseViewModel, HomeDetailViewProtocol {
    
    let image: UIImage
    
    public init(image: UIImage) {
        self.image = image
    }
}
