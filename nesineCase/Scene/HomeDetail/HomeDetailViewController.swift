//
//  HomeDetailViewController.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import UIKit
import TinyConstraints

final class HomeDetailViewController: BaseViewController<HomeDetailViewModel> {
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        configureContents()
    }
}

// MARK: - UILayout
extension HomeDetailViewController {
    
    private func addSubViews() {
        addImageView()
    }
    
    private func addImageView() {
        view.addSubview(imageView)
        imageView.edgesToSuperview(usingSafeArea: true)
    }
}

// MARK: - Configure
extension HomeDetailViewController {
    
    private func configureContents() {
        imageView.image = viewModel.image
        view.backgroundColor = .lightGray
    }
}
