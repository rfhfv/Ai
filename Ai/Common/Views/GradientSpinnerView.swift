//
//  GradientSpinnerView.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

final class GradientSpinnerView: UIView {
    
    private enum Constants {
        static let lineCount: Int = 8
        static let lineWidth: CGFloat = 3
        static let lineHeight: CGFloat = 9
        static let lineCornerRadius: CGFloat = 1.5
        static let animationDuration: TimeInterval = 0.8
    }
    
    private let replicatorLayer = CAReplicatorLayer()
    private let lineLayer = CAShapeLayer()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    // MARK: - Public
    
    func startAnimating() {
        isHidden = false
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1
        fade.toValue = 0.15
        fade.duration = Constants.animationDuration
        fade.repeatCount = .infinity
        fade.timingFunction = CAMediaTimingFunction(name: .linear)
        lineLayer.add(fade, forKey: "fade")
    }
    
    func stopAnimating() {
        lineLayer.removeAnimation(forKey: "fade")
        isHidden = true
    }
    
    func setColor(_ color: UIColor) {
        lineLayer.fillColor = color.cgColor
    }
    
    // MARK: - Private
    
    private func setupLayers() {
        layer.addSublayer(replicatorLayer)
        
        lineLayer.fillColor = UIColor.white.cgColor
        lineLayer.cornerRadius = Constants.lineCornerRadius
        replicatorLayer.addSublayer(lineLayer)
        
        let count = Constants.lineCount
        replicatorLayer.instanceCount = count
        replicatorLayer.instanceDelay = Constants.animationDuration / Double(count)
        
        let angle = CGFloat(2 * Double.pi) / CGFloat(count)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        replicatorLayer.instanceAlphaOffset = -1.0 / Float(count)
    }
    
    private func updateLayout() {
        let size = min(bounds.width, bounds.height)
        replicatorLayer.frame = CGRect(
            x: (bounds.width - size) / 2,
            y: (bounds.height - size) / 2,
            width: size,
            height: size
        )
        
        let center = CGPoint(x: size / 2, y: size / 2)
        let lineH = Constants.lineHeight
        let lineW = Constants.lineWidth
        let offset = size / 2 - lineH - 2
        
        lineLayer.frame = CGRect(
            x: center.x - lineW / 2,
            y: center.y - offset - lineH,
            width: lineW,
            height: lineH
        )
        lineLayer.cornerRadius = Constants.lineCornerRadius
    }
}
