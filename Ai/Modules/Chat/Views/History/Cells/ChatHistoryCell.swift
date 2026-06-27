//
//  ChatHistoryCell.swift
//  Ai
//
//  Created by admin on 26.06.2026.
//

import UIKit

final class ChatHistoryCell: UITableViewCell {
    
    private enum Constants {
        static let cardViewHSize: CGFloat = 64
        static let avatarViewSize: CGFloat = 28
    }
    
    static let reuseId = String(describing: ChatHistoryCell.self)
    
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .cmChocolate
        v.layer.cornerRadius = Size.Common.cornerRadius16
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let avatarView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.ChatHistory.historyStars)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let previewLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.b16.font, alignment: .left, numberOfLines: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let timeLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.r14.font, color: .cmGray, alignment: .left)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let textStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 4
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
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
    
    func configure(with chat: ChatHistoryItem) {
        previewLabel.text = chat.preview
        timeLabel.text = chat.formattedTime
    }
}

private extension ChatHistoryCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        textStack.addArrangedSubviews(previewLabel, timeLabel)
        cardView.addSubviews(avatarView, textStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Insets.s16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Insets.s16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Insets.s12),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.cardViewHSize),
            
            avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Insets.s12),
            avatarView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: Constants.avatarViewSize),
            avatarView.heightAnchor.constraint(equalToConstant: Constants.avatarViewSize),
            
            textStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: Insets.s12),
            textStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Insets.s12),
            textStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
}
