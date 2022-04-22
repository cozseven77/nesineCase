//
//  ImageCell.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//

import UIKit
import TinyConstraints

public class ImageCell: UICollectionViewCell, ReusableView {
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        return imageview
    }()
    
    var viewModel: ImageCellProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubViews()
    }
    
    private func addSubViews() {
        contentView.addSubview(imageView)
        imageView.edgesToSuperview()
        imageView.height(70)
    }
    
    public func set(viewModel: ImageCellProtocol) {
        self.viewModel = viewModel
        self.imageView.image = viewModel.image
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
