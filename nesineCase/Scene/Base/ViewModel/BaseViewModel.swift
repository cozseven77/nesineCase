//
//  BaseViewModel.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import Foundation
import UIKit

protocol BaseViewModelDataSource: AnyObject {
    var showEmptyView: ((UIView) -> Void)? { get set }
    var hideEmptyView: (() -> Void)? { get set }
}

protocol BaseViewModelProtocol: BaseViewModelDataSource {}

class BaseViewModel: BaseViewModelProtocol {
    
    var showEmptyView: ((UIView) -> Void)?
    var hideEmptyView: (() -> Void)?
    
    deinit {
        debugPrint("deinit \(self)")
    }
}
