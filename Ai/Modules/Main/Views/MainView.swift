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
    
    weak var delegate: MainViewDelegate?
    
    private let backgroundGradient: GradientView = {
        let v = GradientView(
            colors: [.cmDarkBLue, .cmBlack, .cmNight],
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
        l.configureLabel(text: Strings.Main.mainTitle, font: Typography.hugeTitleB.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let settingsButton: UIButton = {
        let b = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        b.setImage(UIImage(named: Images.Main.settingsImage), for: .normal)
        b.tintColor = .white.withAlphaComponent(0.7)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
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
            
            settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 40),
            settingsButton.heightAnchor.constraint(equalToConstant: 40),
            
            sparkImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            sparkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            sparkImageView.widthAnchor.constraint(equalToConstant: 60),
            sparkImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: sparkImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            searchBarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            searchBarView.heightAnchor.constraint(equalToConstant: 56),
            
            videoCardView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 24),
            videoCardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            videoCardView.widthAnchor.constraint(equalToConstant: 172),
            videoCardView.heightAnchor.constraint(equalToConstant: 313),
            
            fixCardView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 24),
            fixCardView.leadingAnchor.constraint(equalTo: videoCardView.trailingAnchor, constant: 8),
            fixCardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            fixCardView.heightAnchor.constraint(equalToConstant: 152),
            fixCardView.widthAnchor.constraint(equalToConstant: 178),
            
            summarizeCardView.topAnchor.constraint(equalTo: fixCardView.bottomAnchor, constant: 8),
            summarizeCardView.leadingAnchor.constraint(equalTo: videoCardView.trailingAnchor, constant: 8),
            summarizeCardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            summarizeCardView.heightAnchor.constraint(equalToConstant: 152),
            summarizeCardView.widthAnchor.constraint(equalToConstant: 178)
        ])
    }
}
