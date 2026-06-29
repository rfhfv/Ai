//
//  VideoGenerationRow.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

final class VideoSettingRow: UIView {
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.m16.font, color: .cmGray)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let valueLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.m16.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Init
    
    init(title: String, value: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        valueLabel.text = value
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
}

// MARK: - Setup UI

private extension VideoSettingRow {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .cmChocolate
        clipsToBounds = true
        layer.cornerRadius = Size.Common.cornerRadius20
        
        addSubviews(titleLabel, valueLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
