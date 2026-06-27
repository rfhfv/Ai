//
//  UserMessageCell.swift
//  Ai
//
//  Created by admin on 25.06.2026.
//

import UIKit

final class UserMessageCell: UITableViewCell {
    
    static let reuseId = String(describing: UserMessageCell.self)
    
    private let bubbleView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = Size.Common.cornerRadius16
        v.clipsToBounds = true
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [UIColor.cmBlue.cgColor, UIColor.cmPink.cgColor]
        g.startPoint = CGPoint(x: 0, y: 0.5)
        g.endPoint = CGPoint(x: 1, y: 0.5)
        return g
    }()
    
    private let messageLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.r16.font, alignment: .right)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bubbleView.bounds
    }
    
    // MARK: - Configure
    
    func configure(with text: String) {
        messageLabel.text = text
    }
}

private extension UserMessageCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        bubbleView.layer.insertSublayer(gradientLayer, at: 0)
        bubbleView.addSubview(messageLabel)
        contentView.addSubview(bubbleView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Insets.s12),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Insets.s12),
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Insets.s28),
            bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: Insets.s64),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: Insets.s16),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -Insets.s16),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: Insets.s16),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -Insets.s16)
        ])
    }
}
