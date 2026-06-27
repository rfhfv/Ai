//
//  VideoCardView.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

final class VideoCardView: UIView {
    
    private enum Constants {
        static let iconImageViewSize: CGFloat = 36
        
        static let readyButtonHSize: CGFloat = 32
        static let readyButtonWSize: CGFloat = 150
    }
    
    private let gradientView: GradientView = {
        let v = GradientView(
            colors: [.cmBlue, .cmPink, .cmRed],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
        
        v.layer.cornerRadius = Size.Common.cornerRadius16
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.Main.smallImage)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let backgroundLineImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.Main.lineImage)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Main.videoTitle, font: Typography.m20.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Main.videoSubtitle, font: Typography.r14.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let readyButton: UIButton = {
        let button = UIButton(configuration: makeReadyButtonConfig())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension VideoCardView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    static func makeReadyButtonConfig() -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = Strings.Main.videoButton
        config.image = UIImage(named: Images.Main.playImage)
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .white.withAlphaComponent(0.2)
        config.cornerStyle = .capsule
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var attrs = attrs
            attrs.font = Typography.r12.font
            return attrs
        }
        return config
    }
    
    func setupViews() {
        addSubviews(gradientView, backgroundLineImageView)
        gradientView.addSubviews(iconImageView, titleLabel, subtitleLabel, readyButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundLineImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundLineImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundLineImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundLineImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: Insets.s16),
            iconImageView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: Insets.s16),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconImageViewSize),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconImageViewSize),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: Insets.s12),
            titleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: Insets.s16),
            titleLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -Insets.s16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Insets.s8),
            subtitleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: Insets.s16),
            
            readyButton.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            readyButton.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -Insets.s16),
            readyButton.heightAnchor.constraint(equalToConstant: Constants.readyButtonHSize),
            readyButton.widthAnchor.constraint(equalToConstant: Constants.readyButtonWSize)
        ])
    }
}
