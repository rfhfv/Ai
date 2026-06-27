//
//  LoadingCell.swift
//  Ai
//
//  Created by admin on 25.06.2026.
//

import UIKit

final class LoadingCell: UITableViewCell {
    
    static let reuseId = String(String(describing: LoadingCell.self))
    
    private  enum Constants {
        static let dotSize: CGFloat = 19
        static let dotScaleSmall: CGFloat = 0.6
        static let dotsStackHSize: CGFloat = 51
    }
    
    private let dotsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 4
        s.alignment = .center
        s.clipsToBounds = true
        s.layer.cornerRadius = Size.Common.cornerRadius16
        s.backgroundColor = .cmChocolate
        s.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        s.isLayoutMarginsRelativeArrangement = true
        s.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    private var dotViews: [UIView] = []
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        newSuperview != nil ? startAnimating() : stopAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dotViews.forEach { dot in
            dot.layer.sublayers?
                .compactMap { $0 as? CAGradientLayer }
                .forEach { $0.frame = dot.bounds }
        }
    }
    
    
    // MARK: - Animation
    
    func startAnimating() {
        stopAnimating()
        dotViews.enumerated().forEach { index, dot in
            let delay = Double(index) * 0.15
            animateDot(dot, delay: delay)
        }
    }
    
    func stopAnimating() {
        dotViews.forEach { $0.layer.removeAllAnimations() }
    }
}

private extension LoadingCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func makeDot() -> UIView {
        let dot = UIView()
        dot.clipsToBounds = true
        dot.layer.cornerRadius = Constants.dotSize / 2
        dot.translatesAutoresizingMaskIntoConstraints = false
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.cmBlue.cgColor, UIColor.cmPink.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        dot.layer.insertSublayer(gradient, at: 0)
        
        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: Constants.dotSize),
            dot.heightAnchor.constraint(equalToConstant: Constants.dotSize)
        ])
        
        return dot
    }
    
    
    func animateDot(_ dot: UIView, delay: TimeInterval) {
        dot.transform = .identity
        UIView.animate(
            withDuration: 0.5,
            delay: delay,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                dot.transform = CGAffineTransform(scaleX: Constants.dotScaleSmall, y: Constants.dotScaleSmall)
                    .concatenating(CGAffineTransform(translationX: 0, y: -4))
            }
        )
    }
    
    func setupViews() {
        contentView.addSubview(dotsStack)
        
        for _ in 0..<3 {
            let dot = makeDot()
            dotViews.append(dot)
            dotsStack.addArrangedSubview(dot)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dotsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Insets.s16),
            dotsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Insets.s12),
            dotsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Insets.s12),
            dotsStack.heightAnchor.constraint(equalToConstant: Constants.dotsStackHSize)
        ])
    }
}
