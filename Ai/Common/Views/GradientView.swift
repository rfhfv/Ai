//
//  GradientView.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

final class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    var colors: [UIColor] = [] {
        didSet { updateGradient() }
    }
    
    var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet { gradientLayer.startPoint = startPoint }
    }
    
    var endPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet { gradientLayer.endPoint = endPoint }
    }
    
    init(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(frame: .zero)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient() {
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
        updateGradient()
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors.map { $0.cgColor }
    }
}
