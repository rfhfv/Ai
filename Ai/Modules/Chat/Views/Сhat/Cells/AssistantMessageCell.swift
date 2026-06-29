//
//  AssistantMessageCell.swift
//  Ai
//
//  Created by admin on 25.06.2026.
//

import UIKit

final class AssistantMessageCell: UITableViewCell {
    
    static let reuseId = String(describing: AssistantMessageCell.self)
    
    private let backView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = Size.Common.cornerRadius16
        v.clipsToBounds = true
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        v.backgroundColor = .cmChocolate
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let messageLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.r16.font, alignment: .left)
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
    
    // MARK: - Configure
    
    func configure(with text: String) {
        messageLabel.text = text
    }
}

private extension AssistantMessageCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        backView.addSubview(messageLabel)
        contentView.addSubview(backView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Insets.s12),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Insets.s12),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Insets.s16),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Insets.s28),
            
            messageLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: Insets.s12),
            messageLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -Insets.s16),
            messageLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Insets.s16),
            messageLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Insets.s16)
        ])
    }
}
