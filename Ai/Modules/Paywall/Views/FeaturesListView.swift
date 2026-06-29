//
//  FeaturesListView.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

final class FeaturesListView: UIView {
    
    private let stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = Insets.s16
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
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
    
    func configure(with features: [(icon: String, text: String)]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        features.forEach { icon, text in
            let item = FeatureItemView()
            item.configure(icon: icon, text: text)
            stackView.addArrangedSubview(item)
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
