//
//  FeatureCardView.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

final class FeatureCardView: UIView {
    
    private enum Constants {
        static let imageViewSize: CGFloat = 36
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.m16.font, alignment: .left)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.m12.font, color: .cmGray, alignment: .left)
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
    
    func configure(image: String, title: String, subtitle: String) {
        imageView.image = UIImage(named: image)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

// MARK: - Setup UI

private extension FeatureCardView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        layer.cornerRadius = Size.Common.cornerRadius16
        clipsToBounds = true
        backgroundColor = .cmChocolate
        addSubviews(imageView, titleLabel, subtitleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: Insets.s16),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Insets.s24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Insets.s8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16)
        ])
    }
}
