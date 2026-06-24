//
//  CustomSearchBar.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

final class SearchBarView: UIView {
    
    private var gradientBorderLayer: CAGradientLayer?
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = Strings.Main.searchPlaceholder
        tf.textColor = .white
        tf.isUserInteractionEnabled = false
        tf.attributedPlaceholder = NSAttributedString(
            string: Strings.Main.searchPlaceholder,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.Main.fewSparksImage)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientBorder()
    }
}

private extension SearchBarView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func updateGradientBorder() {
        gradientBorderLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.cmPink.cgColor, UIColor.cmBLue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = layer.cornerRadius
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: layer.cornerRadius).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        gradient.mask = shape
        
        layer.addSublayer(gradient)
        gradientBorderLayer = gradient
    }
    
    func setupViews() {
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        layer.cornerRadius = 20
        clipsToBounds = false
        
        addSubviews(iconImageView, textField)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
