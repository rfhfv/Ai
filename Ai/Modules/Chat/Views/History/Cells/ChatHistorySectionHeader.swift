//
//  ChatHistorySectionHeader.swift
//  Ai
//
//  Created by admin on 26.06.2026.
//

import UIKit

final class ChatHistorySectionHeader: UITableViewHeaderFooterView {
    
    static let reuseId = String(describing: ChatHistorySectionHeader.self)
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.b20.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Insets.s16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
