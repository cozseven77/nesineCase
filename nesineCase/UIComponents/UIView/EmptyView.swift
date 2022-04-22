//
//  EmptyView.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import UIKit
import TinyConstraints

public class EmptyView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let imageViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.size(CGSize(width: 64, height: 64))
        imageView.image = UIImage(named: "empty")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    // swiftlint:disable fatal_error unavailable_function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // swiftlint:enable fatal_error unavailable_function
    
}

// MARK: - UILayout
extension EmptyView {
    
    private func addSubViews() {
        addSubview(stackView)
        stackView.edgesToSuperview()
        stackView.addArrangedSubview(imageViewContainer)
        stackView.setCustomSpacing(24, after: imageViewContainer)
        
        imageViewContainer.addSubview(imageView)
        imageView.edgesToSuperview(excluding: [.leading, .trailing])
        imageView.centerXToSuperview()
    }
}
