//
//  FilterCell.swift
//  Ai
//
//  Created by admin on 27.06.2026.
//

//
//  FilterCell.swift
//  Ai
//
//  Created by admin on 27.06.2026.
//

import UIKit

final class FilterCell: UICollectionViewCell {
    
    static let reuseId = String(describing: FilterCell.self)
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.r14.font, color: .cmGray)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [UIColor.cmBlue.cgColor, UIColor.cmPink.cgColor]
        g.startPoint = CGPoint(x: 0, y: 0.5)
        g.endPoint = CGPoint(x: 1, y: 0.5)
        return g
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    // MARK: - Configure
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        
        if isSelected {
            contentView.layer.insertSublayer(gradientLayer, at: 0)
            titleLabel.textColor = .white
        } else {
            gradientLayer.removeFromSuperlayer()
            titleLabel.textColor = .white.withAlphaComponent(0.6)
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.layer.cornerRadius = Size.Common.cornerRadius16
        contentView.clipsToBounds = true
        contentView.backgroundColor = .cmChocolate
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Insets.s16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Insets.s16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
