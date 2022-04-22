//
//  SectionTitleHeaderView.swift
//  nesineCase
//
//  Created by can ozseven on 21.04.2022.
//
import UIKit
import TinyConstraints

public final class SectionTitleHeaderView: UICollectionReusableView, ReusableView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    public var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
        configureContents()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        titleLabel.edgesToSuperview(excluding: [.top, .left], insets: .bottom(8) + .right(16))
        titleLabel.leadingToSuperview().constant = 16
    }
    
    private func configureContents() {
        backgroundColor = .clear
    }
}
