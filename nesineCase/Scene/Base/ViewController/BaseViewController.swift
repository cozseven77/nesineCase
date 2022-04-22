//
//  BaseViewController.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import UIKit

class BaseViewController<V: BaseViewModelProtocol>: UIViewController {
    
    var viewModel: V
    
    init(viewModel: V) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContents()
    }
    
    private func configureContents() {
        view.backgroundColor = .white
    }
    
    deinit {
        debugPrint("deinit \(self)")
    }
}
