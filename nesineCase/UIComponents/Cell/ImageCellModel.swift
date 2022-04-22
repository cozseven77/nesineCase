//
//  ImageCellModel.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import UIKit

public protocol ImageCellDataSource {
    var image: UIImage? { get }
}

public protocol ImageCellProtocol: ImageCellDataSource {}

public final class ImageCellModel: ImageCellProtocol {
    
    public var image: UIImage?
    
    public init(image: UIImage?) {
        self.image = image
        
    }
    
}
