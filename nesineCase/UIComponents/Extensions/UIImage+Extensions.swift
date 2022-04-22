//
//  UIImage+Extensions.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//
import UIKit

extension UIImage {

    func getSize() -> Double {

        guard let data = self.pngData() else {
            return 0
        }

        let size: Double = Double(data.count) / 1024
        return size
    }
}
