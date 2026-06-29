//
//  FeatureItemView.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

final class FeatureItemView: UIView {
    
    private enum Constants {
        static let iconImageWSize: CGFloat = 24
        static let itemHSize: CGFloat = 24
    }
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let textLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.m16.font, alignment: .left, numberOfLines: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(icon: String, text: String) {
        iconImage.image = UIImage(named: icon)
        textLabel.text = text
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        addSubviews(iconImage, textLabel)
        
        NSLayoutConstraint.activate([
            iconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s37),
            iconImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: Constants.iconImageWSize),
            
            textLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: Insets.s8),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            
            heightAnchor.constraint(equalToConstant: Constants.itemHSize)
        ])
    }
}
