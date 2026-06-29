//
//  CustomButton.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

final class CustomButton: UIView {
    
    private enum  Constants {
        static let iconViewSize: CGFloat = 24
    }
    
    var onTap: (() -> Void)?
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.r14.font)
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
    
    func configure(image: String, title: String) {
        iconView.image = UIImage(named: image)
        titleLabel.text = title
    }
}

// MARK: - Setup UI

private extension CustomButton {
    func setupUI() {
        setupViews()
        setupConstraints()
        setupTarget()
    }
    
    func setupTarget() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    @objc func didTap() {
        onTap?()
    }
    
    func setupViews() {
        backgroundColor = UIColor.cmGray.withAlphaComponent(0.9)
        layer.cornerRadius = Size.Common.cornerRadius20
        clipsToBounds = true
        
        addSubviews(iconView, titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s12),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: Constants.iconViewSize),
            iconView.heightAnchor.constraint(equalToConstant: Constants.iconViewSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Insets.s8),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s12)
        ])
    }
}
