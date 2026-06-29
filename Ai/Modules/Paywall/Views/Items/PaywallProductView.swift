//
//  PaywallProductView.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

final class PaywallProductView: UIView {
    
    private enum Constants {
        static let badgeViewHSize: CGFloat = 25
        static let badgeViewWSize: CGFloat = 102
        static let borderWidthSize: CGFloat = 1.5
    }
    
    private let containerView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = Size.Common.cornerRadius20
        v.layer.borderWidth = Constants.borderWidthSize
        v.layer.borderColor = UIColor.cmGray.cgColor
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.r20.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let originalPriceLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.r14.font, color: .cmDarkGray)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let badgeView: GradientView = {
        let v = GradientView(
            colors: [.cmBlue, .cmPink],
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5)
        )
        v.layer.cornerRadius = Size.Common.cornerRadius12
        v.clipsToBounds = true
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let badgeLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.r14.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let selectedBorderLayer = CAGradientLayer()
    
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
        selectedBorderLayer.frame = bounds
        updateBorderMask()
    }
    
    // MARK: - Public
    
    func configure(with item: PaywallProductItem, isSelected: Bool) {
        titleLabel.text = item.title
        
        if let original = item.originalPrice {
            let attrs: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue),
                .foregroundColor: UIColor.cmGray
            ]
            originalPriceLabel.attributedText = NSAttributedString(string: original, attributes: attrs)
        }
        
        if let badge = item.badge {
            badgeView.isHidden = false
            badgeLabel.text = badge
        } else {
            badgeView.isHidden = true
        }
        
        setSelected(isSelected)
    }
    
    func configureMock(title: String, originalPrice: String?, badge: String?, isSelected: Bool) {
        titleLabel.text = title
        if let original = originalPrice {
            let attrs: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue),
                .foregroundColor: UIColor.cmGray
            ]
            originalPriceLabel.attributedText = NSAttributedString(string: original, attributes: attrs)
        }
        if let badge {
            badgeView.isHidden = false
            badgeLabel.text = badge
        }
        setSelected(isSelected)
    }
    
    func setSelected(_ selected: Bool) {
        selectedBorderLayer.isHidden = !selected
        containerView.layer.borderColor = selected ? UIColor.clear.cgColor : UIColor.white.withAlphaComponent(0.15).cgColor
    }
}

// MARK: - Private

private extension PaywallProductView {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func updateBorderMask() {
        let mask = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: Size.Common.cornerRadius20)
        let innerPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 1.5, dy: 1.5), cornerRadius: 20 - 1.5)
        path.append(innerPath)
        mask.path = path.cgPath
        mask.fillRule = .evenOdd
        selectedBorderLayer.mask = mask
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(originalPriceLabel)
        containerView.addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        
        selectedBorderLayer.colors = [UIColor.cmBlue.cgColor, UIColor.cmPink.cgColor]
        selectedBorderLayer.startPoint = CGPoint(x: 0, y: 0.5)
        selectedBorderLayer.endPoint = CGPoint(x: 1, y: 0.5)
        selectedBorderLayer.isHidden = true
        layer.insertSublayer(selectedBorderLayer, at: 0)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: Insets.s2),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s2),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s2),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Insets.s2),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Insets.s16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Insets.s16),
            
            originalPriceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            originalPriceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Insets.s4),
            
            badgeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Insets.s16),
            badgeView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            badgeView.heightAnchor.constraint(equalToConstant: Constants.badgeViewHSize),
            badgeView.widthAnchor.constraint(equalToConstant: Constants.badgeViewWSize),
            
            badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: Insets.s4),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -Insets.s4),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: Insets.s8),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -Insets.s8)
        ])
    }
}
