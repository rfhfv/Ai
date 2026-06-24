//
//  VideoCardView.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

final class VideoCardView: UIView {
    
    private let gradientView: GradientView = {
        let v = GradientView(
            colors: [.cmBLue, .cmPink, .cmRed],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
        
        v.layer.cornerRadius = 16
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
        l.configureLabel(text: Strings.Main.videoTitle, font: Typography.largeM.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Main.videoSubtitle, font: Typography.mediumR.font)
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
            attrs.font = Typography.smallR.font
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
            
            iconImageView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 36),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
            
            readyButton.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            readyButton.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 32),
            readyButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
