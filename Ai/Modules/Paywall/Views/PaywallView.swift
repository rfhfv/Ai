//
//  PaywallView.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit
import ApphudSDK
import StoreKit

protocol PaywallViewDelegate: AnyObject {
    func didTapClose()
    func didTapUnlock()
    func didTapRestore()
    func didSelectProduct(at index: Int)
    func didTapPrivacy()
    func didTapTerms()
}

final class PaywallView: UIView {
    
    private enum Constants {
        static let closeButtonSize: CGFloat = 32
        static let titleLabelHSize: CGFloat = 82
        static let cancelAnytimeLabelHSize: CGFloat = 14
        static let unlockGradientHSize: CGFloat = 60
        static let itemHSize: CGFloat = 72
    }
    
    weak var delegate: PaywallViewDelegate?
    
    private var productViews: [PaywallProductView] = []
    private var selectedIndex: Int = 0
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.Common.backgroundImage)
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let closeButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(systemName: Images.Paywall.xMarkImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Paywall.title, font: Typography.b34.font, numberOfLines: 2)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let featuresStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = Insets.s16
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    private let feature1: FeatureItemView = {
        let v = FeatureItemView()
        v.configure(icon: Images.Paywall.starsImage, text: Strings.Paywall.starsSubtitle)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let feature2: FeatureItemView = {
        let v = FeatureItemView()
        v.configure(icon: Images.Paywall.textImage, text: Strings.Paywall.textSubtitle)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let feature3: FeatureItemView = {
        let v = FeatureItemView()
        v.configure(icon: Images.Paywall.infoImage, text: Strings.Paywall.infoSubtitle)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let feature4: FeatureItemView = {
        let v = FeatureItemView()
        v.configure(icon: Images.Paywall.contentImage, text: Strings.Paywall.contentSubtitle)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let productsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = Insets.s12
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    private let cancelAnytimeLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Paywall.cancelTitle, font: Typography.r14.font, color: .cmGray)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let unlockGradient: GradientView = {
        let v = GradientView(
            colors: [.cmBlue, .cmPink],
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5)
        )
        v.layer.cornerRadius = Size.Common.cornerRadius26
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let unlockButton: UIButton = {
        let b = UIButton()
        b.setTitle(Strings.Paywall.unlockNowText, for: .normal)
        b.titleLabel?.font = Typography.b20.font
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .clear
        b.layer.cornerRadius = Size.Common.cornerRadius26
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let footerStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = Insets.s16
        s.distribution = .equalSpacing
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .white
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
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
    
    func configure(with items: [PaywallProductItem], selectedIndex: Int) {
        productsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        productViews.removeAll()
        
        items.enumerated().forEach { index, item in
            let view = PaywallProductView()
            view.configure(with: item, isSelected: index == selectedIndex)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: Constants.itemHSize).isActive = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProduct(_:)))
            view.tag = index
            view.addGestureRecognizer(tap)
            
            productViews.append(view)
            productsStack.addArrangedSubview(view)
        }
    }
    
    func configureMock(with items: [MockPaywallItem], selectedIndex: Int) {
        productsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        productViews.removeAll()
        
        items.enumerated().forEach { index, item in
            let view = PaywallProductView()
            view.configureMock(title: item.title, originalPrice: item.originalPrice,
                               badge: item.badge, isSelected: index == selectedIndex)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: Constants.itemHSize).isActive = true
            view.tag = index
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProduct(_:))))
            productViews.append(view)
            productsStack.addArrangedSubview(view)
        }
    }
    
    @objc private func didTapProduct(_ gesture: UITapGestureRecognizer) {
        let index = gesture.view?.tag ?? 0
        selectedIndex = index
        productViews.enumerated().forEach { i, view in
            view.setSelected(i == index)
        }
        delegate?.didSelectProduct(at: index)
    }
    
    func showLoading(_ show: Bool) {
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        unlockButton.isEnabled = !show
        unlockButton.alpha = show ? 0.5 : 1
    }
}

// MARK: - Setup UI

private extension PaywallView {
    
    func setupUI() {
        setupViews()
        setupConstraints()
        setupActions()
        setupFooter()
    }
    
    func setupFooter() {
        let privacyButton = makeFooterButton(title: Strings.Paywall.privacyPolicyText)
        let restoreButton = makeFooterButton(title: Strings.Paywall.restorePurchasesText)
        let termsButton = makeFooterButton(title: Strings.Paywall.termsOfUseText)
        
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        
        footerStack.addArrangedSubviews(privacyButton, restoreButton, termsButton)
    }
    
    func setupActions() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        unlockButton.addTarget(self, action: #selector(didTapUnlock), for: .touchUpInside)
    }
    
    @objc func didTapClose() {
        delegate?.didTapClose()
    }
    
    @objc func didTapUnlock() {
        delegate?.didTapUnlock()
    }
    
    @objc func didTapRestore() {
        delegate?.didTapRestore()
    }
    
    @objc func didTapPrivacy() {
        delegate?.didTapPrivacy()
    }
    
    @objc func didTapTerms() {
        delegate?.didTapTerms()
    }
    
    func makeFooterButton(title: String) -> UIButton {
        let b = UIButton(type: .custom)
        b.setTitle(title, for: .normal)
        b.setTitleColor(.cmGray, for: .normal)
        b.titleLabel?.font = Typography.r12.font
        return b
    }
    
    func setupViews() {
        featuresStack.addArrangedSubviews(feature1, feature2, feature3, feature4)
        
        addSubviews(
            backgroundImageView,
            closeButton,
            titleLabel,
            featuresStack,
            productsStack,
            cancelAnytimeLabel,
            unlockGradient,
            unlockButton,
            footerStack,
            activityIndicator
        )
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Insets.s16),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonSize),
            
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Insets.s106),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHSize),
            
            featuresStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Insets.s32),
            featuresStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s24),
            featuresStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s24),
            
            activityIndicator.topAnchor.constraint(equalTo: featuresStack.bottomAnchor, constant: Insets.s16),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            productsStack.topAnchor.constraint(equalTo: featuresStack.bottomAnchor, constant: Insets.s32),
            productsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            productsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            
            cancelAnytimeLabel.topAnchor.constraint(equalTo: productsStack.bottomAnchor, constant: Insets.s24),
            cancelAnytimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelAnytimeLabel.heightAnchor.constraint(equalToConstant: Constants.cancelAnytimeLabelHSize),
            
            unlockGradient.topAnchor.constraint(equalTo: cancelAnytimeLabel.bottomAnchor, constant: Insets.s20),
            unlockGradient.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            unlockGradient.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            unlockGradient.heightAnchor.constraint(equalToConstant: Constants.unlockGradientHSize),
            
            unlockButton.topAnchor.constraint(equalTo: unlockGradient.topAnchor),
            unlockButton.leadingAnchor.constraint(equalTo: unlockGradient.leadingAnchor),
            unlockButton.trailingAnchor.constraint(equalTo: unlockGradient.trailingAnchor),
            unlockButton.bottomAnchor.constraint(equalTo: unlockGradient.bottomAnchor),
            
            footerStack.topAnchor.constraint(equalTo: unlockButton.bottomAnchor, constant: Insets.s16),
            footerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s24),
            footerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s24),
            footerStack.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -Insets.s8)
        ])
    }
}
