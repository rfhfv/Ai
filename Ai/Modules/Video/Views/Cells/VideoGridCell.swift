//
//  VideoGridCell.swift
//  Ai
//
//  Created by admin on 27.06.2026.
//

//import UIKit
//
//final class VideoGridCell: UICollectionViewCell {
//    
//    private enum Constants {
//        static let gradientViewHSize: CGFloat = 80
//    }
//    
//    static let reuseId = String(describing: VideoGridCell.self)
//    
//    private let imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
//    
//    private let gradientView: UIView = {
//        let v = UIView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
//    
//    private let gradientLayer: CAGradientLayer = {
//        let g = CAGradientLayer()
//        g.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
//        g.startPoint = CGPoint(x: 0.5, y: 0)
//        g.endPoint = CGPoint(x: 0.5, y: 1)
//        return g
//    }()
//    
//    private let titleLabel: UILabel = {
//        let l = UILabel()
//        l.configureLabel(font: Typography.r16.font)
//        l.translatesAutoresizingMaskIntoConstraints = false
//        return l
//    }()
//    
//    // MARK: - Init
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = gradientView.bounds
//    }
//    
//    // MARK: - Configure
//    
//    func configure(title: String, image: UIImage? = nil) {
//        titleLabel.text = title
//        imageView.image = image
//    }
//}
//
//// MARK: - Setup UI
//
//private extension VideoGridCell {
//    func setupUI() {
//        setupViews()
//        setupConstraints()
//    }
//    
//    func setupViews() {
//        contentView.layer.cornerRadius = Size.Common.cornerRadius16
//        contentView.clipsToBounds = true
//        
//        gradientView.layer.addSublayer(gradientLayer)
//        contentView.addSubviews(imageView, gradientView, titleLabel)
//    }
//    
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            gradientView.heightAnchor.constraint(equalToConstant: Constants.gradientViewHSize),
//            
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Insets.s10),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Insets.s10),
//            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Insets.s10)
//        ])
//    }
//}

//
//  VideoGridCell.swift
//  Ai
//
//  Created by admin on 27.06.2026.
//

import UIKit

final class VideoGridCell: UICollectionViewCell {
    
    static let reuseId = String(describing: VideoGridCell.self)
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = Size.Common.cornerRadius16
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.r16.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    // MARK: - Configure
    
    func configure(title: String, image: UIImage? = nil) {
        titleLabel.text = title
        imageView.image = image
    }
}

// MARK: - Setup UI

private extension VideoGridCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.backgroundColor = .clear
        
        containerView.addSubviews(imageView, titleLabel)
        contentView.addSubview(containerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Insets.s10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Insets.s10),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Insets.s10)
        ])
    }
}
