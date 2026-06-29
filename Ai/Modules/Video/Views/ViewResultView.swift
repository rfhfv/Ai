//
//  ViewResultView.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

protocol VideoResultViewDelegate: AnyObject {
    func didTapBack()
    func didTapShare()
    func didTapDownload()
    func didTapReplace()
    func didTapPlay()
}

final class VideoResultView: UIView {
    
    private enum Constants {
        static let topBarHSize: CGFloat = 100
        
        static let loadingImageViewHSize: CGFloat = 444
        static let loadingImageViewWSize: CGFloat = 316
        
        static let previewImageViewHSize: CGFloat = 611
        static let previewImageViewWSize: CGFloat = 358
        
        static let replaceButtonHSize: CGFloat =  40
        static let replaceButtonWSize: CGFloat = 109
        
        static let playButtonSize: CGFloat = 80
        static let gradientViewHSize: CGFloat = 50
        static let successBubbleWSize: CGFloat = 200
    }
    
    weak var delegate: VideoResultViewDelegate?
    
    // MARK: - Top Bar
    
    private let topBar: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let backButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: Images.Common.backImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.b20.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Loading State
    
    private let loadingView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let loadingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.Result.loadingImage)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let generationTitleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Result.generationTitle, font: Typography.b20.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let generationSubtitleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Result.generationSubTitle, font: Typography.r16.font, color: .cmGray)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Result State
    
    private let resultView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = Size.Common.cornerRadius16
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: Images.Result.resultImage)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let replaceButton: CustomButton = {
        let b = CustomButton()
        b.configure(image: Images.Result.replaceImage, title: Strings.Result.replaceText)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let playButton: UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(named: Images.Result.playVideoImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.contentHorizontalAlignment = .fill
        b.contentVerticalAlignment = .fill
        b.backgroundColor = .clear
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let shareGradientView = makeActionGradient()
    private let downloadGradientView = makeActionGradient()
    
    private let shareButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = .cmChocolate
        b.layer.cornerRadius = Size.Common.cornerRadius20
        b.clipsToBounds = true
        b.setTitle(Strings.Result.shareText, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = Typography.b16.font
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let downloadButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = .cmChocolate
        b.layer.cornerRadius = Size.Common.cornerRadius20
        b.clipsToBounds = true
        b.setTitle(Strings.Result.downloadText, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = Typography.b16.font
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let successBubble: UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .cmChocolate
        v.layer.cornerRadius = Size.Common.cornerRadius20
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let successIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.Result.checkmarkImage)
        iv.tintColor = .cmPink
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let successLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Result.saveVideoText,font: Typography.r16.font)
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
    
    // MARK: - Public
    
    func showLoadingState() {
        loadingView.isHidden = false
        resultView.isHidden = true
        titleLabel.text = ""
    }
    
    func showResultState(with model: VideoGenerationModel) {
        loadingView.isHidden = true
        resultView.isHidden = false
        titleLabel.text = Strings.Result.title
        if let image = model.thumbnail as UIImage? {
            previewImageView.image = image
        }
    }
    
    func showSavedToGallery() {
        UIView.animate(withDuration: 0.3) {
            self.successBubble.isHidden = false
            self.successBubble.alpha = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.3) {
                    self.successBubble.alpha = 0
                }
            }
        }
    }
    
    func showError(_ message: String) {
        print("VideoResultView error: \(message)")
    }
}

// MARK: - Setup UI

private extension VideoResultView {
    
    static func makeActionGradient() -> GradientView {
        let v = GradientView(
            colors: [.cmPink, .cmBlue],
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5)
        )
        v.layer.cornerRadius = Size.Common.cornerRadius20
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
    
    func setupUI() {
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    func setupViews() {
        backgroundColor = .black
        
        topBar.addSubviews(backButton, titleLabel)
        loadingView.addSubviews(loadingImageView, generationTitleLabel, generationSubtitleLabel)
        successBubble.addSubviews(successIconView, successLabel)
        
        resultView.addSubviews(
            previewImageView,
            replaceButton,
            playButton,
            shareGradientView,
            shareButton,
            downloadGradientView,
            downloadButton,
            successBubble
        )
        
        addSubviews(topBar, loadingView, resultView)
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
        
        replaceButton.onTap = { [weak self] in
            self?.delegate?.didTapReplace()
        }
    }
    
    @objc func didTapBack() {
        delegate?.didTapBack()
    }
    
    @objc func didTapPlay() {
        delegate?.didTapPlay()
    }
    
    @objc func didTapShare() {
        animateButtonGradient(gradientView: shareGradientView, button: shareButton)
        delegate?.didTapShare()
    }
    
    @objc func didTapDownload() {
        animateButtonGradient(gradientView: downloadGradientView, button: downloadButton)
        delegate?.didTapDownload()
    }
    
    func animateButtonGradient(gradientView: GradientView, button: UIButton) {
        button.backgroundColor = .clear
        UIView.animate(withDuration: 0.3) {
            gradientView.alpha = 1
        }
    }
    
    func setupConstraints() {
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = (screenWidth - 16 * 2 - 8) / 2
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: Constants.topBarHSize),
            
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: Insets.s56),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            backButton.widthAnchor.constraint(equalToConstant: Insets.s32),
            backButton.heightAnchor.constraint(equalToConstant: Insets.s32),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            // Loading
            loadingView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingImageView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: Insets.s80),
            loadingImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingImageView.heightAnchor.constraint(equalToConstant: Constants.loadingImageViewHSize),
            loadingImageView.widthAnchor.constraint(equalToConstant: Constants.loadingImageViewWSize),
            
            generationTitleLabel.topAnchor.constraint(equalTo: loadingImageView.bottomAnchor, constant: Insets.s40),
            generationTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            generationSubtitleLabel.topAnchor.constraint(equalTo: generationTitleLabel.bottomAnchor, constant: Insets.s8),
            generationSubtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Result
            resultView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            resultView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            previewImageView.topAnchor.constraint(equalTo: resultView.topAnchor, constant: Insets.s10),
            previewImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            previewImageView.heightAnchor.constraint(equalToConstant: Constants.previewImageViewHSize),
            previewImageView.widthAnchor.constraint(equalToConstant: Constants.previewImageViewWSize),
            
            replaceButton.topAnchor.constraint(equalTo: previewImageView.topAnchor, constant: Insets.s16),
            replaceButton.trailingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: -Insets.s16),
            replaceButton.heightAnchor.constraint(equalToConstant: Constants.replaceButtonHSize),
            replaceButton.widthAnchor.constraint(equalToConstant: Constants.replaceButtonWSize),
            
            playButton.centerXAnchor.constraint(equalTo: previewImageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: previewImageView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: Constants.playButtonSize),
            playButton.heightAnchor.constraint(equalToConstant: Constants.playButtonSize),
            
            // Share
            shareGradientView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: Insets.s16),
            shareGradientView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            shareGradientView.heightAnchor.constraint(equalToConstant: Constants.gradientViewHSize),
            shareGradientView.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            shareButton.topAnchor.constraint(equalTo: shareGradientView.topAnchor),
            shareButton.leadingAnchor.constraint(equalTo: shareGradientView.leadingAnchor),
            shareButton.trailingAnchor.constraint(equalTo: shareGradientView.trailingAnchor),
            shareButton.bottomAnchor.constraint(equalTo: shareGradientView.bottomAnchor),
            
            // Download
            downloadGradientView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: Insets.s16),
            downloadGradientView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            downloadGradientView.heightAnchor.constraint(equalToConstant: Constants.gradientViewHSize),
            downloadGradientView.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            downloadButton.topAnchor.constraint(equalTo: downloadGradientView.topAnchor),
            downloadButton.leadingAnchor.constraint(equalTo: downloadGradientView.leadingAnchor),
            downloadButton.trailingAnchor.constraint(equalTo: downloadGradientView.trailingAnchor),
            downloadButton.bottomAnchor.constraint(equalTo: downloadGradientView.bottomAnchor),
            
            // Success bubble
            successBubble.centerXAnchor.constraint(equalTo: centerXAnchor),
            successBubble.centerYAnchor.constraint(equalTo: centerYAnchor),
            successBubble.widthAnchor.constraint(equalToConstant: Constants.successBubbleWSize),
            
            successIconView.topAnchor.constraint(equalTo: successBubble.topAnchor, constant: Insets.s24),
            successIconView.centerXAnchor.constraint(equalTo: successBubble.centerXAnchor),
            successIconView.widthAnchor.constraint(equalToConstant: Insets.s24),
            successIconView.heightAnchor.constraint(equalToConstant: Insets.s24),
            
            successLabel.topAnchor.constraint(equalTo: successIconView.bottomAnchor, constant: Insets.s12),
            successLabel.leadingAnchor.constraint(equalTo: successBubble.leadingAnchor, constant: Insets.s16),
            successLabel.trailingAnchor.constraint(equalTo: successBubble.trailingAnchor, constant: -Insets.s16),
            successLabel.bottomAnchor.constraint(equalTo: successBubble.bottomAnchor, constant: -Insets.s24)
        ])
    }
}
