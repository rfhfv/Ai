//
//  MainView.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func didTapSearch()
    func didTapVideoCard()
}

final class MainView: UIView {
    
    private enum Constants {
        static let settingsButtonSize: CGFloat = 40
        static let sparkImageViewSize: CGFloat = 60
        static let searchBarViewSize: CGFloat = 56
        
        static let videoCardViewHSize: CGFloat = 313
        static let videoCardViewWSize: CGFloat = 172
        
        static let smallCardViewHSize: CGFloat = 152
    }
    
    weak var delegate: MainViewDelegate?
    
    private let backgroundGradient: GradientView = {
        let v = GradientView(
            colors: [.cmDarkBlue, .cmBlack, .cmNight],
            startPoint: CGPoint(x: 0.5, y: 0),
            endPoint: CGPoint(x: 0.5, y: 1)
        )
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let searchBarView: SearchBarView = {
        let v = SearchBarView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let videoCardView: VideoCardView = {
        let c = VideoCardView()
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    
    private let fixCardView: FeatureCardView = {
        let v = FeatureCardView()
        v.configure(image: Images.Main.fixImage, title: Strings.Main.fixCardTitle, subtitle: Strings.Main.fixCardSubtitle)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let summarizeCardView: FeatureCardView = {
        let v = FeatureCardView()
        v.configure(image: Images.Main.summarizeImage, title: Strings.Main.SummarizeCardTitle, subtitle: Strings.Main.SummarizeCardSubtitle)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let sparkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.Main.sparksImage)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Main.mainTitle, font: Typography.b28.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let settingsButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: Images.Main.settingsImage), for: .normal)
        b.alpha = 0.7
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupGestures() {
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        searchBarView.addGestureRecognizer(searchTap)
        searchBarView.isUserInteractionEnabled =  true
        
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoCardTapped))
        videoCardView.addGestureRecognizer(videoTap)
        videoCardView.isUserInteractionEnabled = true
    }
    
    @objc func searchTapped() {
        delegate?.didTapSearch()
    }
    
    @objc func videoCardTapped() {
        delegate?.didTapVideoCard()
    }
    
    func setupViews() {
        addSubviews(backgroundGradient, sparkImageView, titleLabel, searchBarView, videoCardView, fixCardView, summarizeCardView, settingsButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundGradient.topAnchor.constraint(equalTo: topAnchor),
            backgroundGradient.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundGradient.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundGradient.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: Insets.s80),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s20),
            settingsButton.widthAnchor.constraint(equalToConstant: Constants.settingsButtonSize),
            settingsButton.heightAnchor.constraint(equalToConstant: Constants.settingsButtonSize),
            
            sparkImageView.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: Insets.s24),
            sparkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            sparkImageView.widthAnchor.constraint(equalToConstant: Constants.sparkImageViewSize),
            sparkImageView.heightAnchor.constraint(equalToConstant: Constants.sparkImageViewSize),
            
            titleLabel.topAnchor.constraint(equalTo: sparkImageView.bottomAnchor, constant: Insets.s16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s20),
            
            searchBarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Insets.s24),
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s12),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s12),
            searchBarView.heightAnchor.constraint(equalToConstant: Constants.searchBarViewSize),
            
            videoCardView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: Insets.s40),
            videoCardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s20),
            videoCardView.widthAnchor.constraint(equalToConstant: Constants.videoCardViewWSize),
            videoCardView.heightAnchor.constraint(equalToConstant: Constants.videoCardViewHSize),
            
            fixCardView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: Insets.s40),
            fixCardView.leadingAnchor.constraint(equalTo: videoCardView.trailingAnchor, constant: Insets.s8),
            fixCardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            fixCardView.heightAnchor.constraint(equalToConstant: Constants.smallCardViewHSize),
            
            summarizeCardView.topAnchor.constraint(equalTo: fixCardView.bottomAnchor, constant: Insets.s8),
            summarizeCardView.leadingAnchor.constraint(equalTo: videoCardView.trailingAnchor, constant: Insets.s8),
            summarizeCardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            summarizeCardView.heightAnchor.constraint(equalToConstant: Constants.smallCardViewHSize)
        ])
    }
}
