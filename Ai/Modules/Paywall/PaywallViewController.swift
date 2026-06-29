//
//  PaywallViewController.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit
import ApphudSDK

final class PaywallViewController: UIViewController {
    
    private let paywallView = PaywallView()
    private let apphud: ApphudServiceProtocol
    
    private var products: [ApphudProduct] = []
    private var selectedIndex: Int = 0
    
    var onPurchaseSuccess: (() -> Void)?
    var onClose: (() -> Void)?
    
    // MARK: - Init
    
    init(apphud: ApphudServiceProtocol = ApphudService.shared) {
        self.apphud = apphud
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = paywallView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        loadProducts()
    }
}

// MARK: - Private

private extension PaywallViewController {
    
    func setupDelegates() {
        paywallView.delegate = self
    }
    
    func loadProducts() {
        paywallView.showLoading(true)
        apphud.fetchPaywall { [weak self] products in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.paywallView.showLoading(false)
                
                if products.isEmpty {
                    let mockItems = [
                        MockPaywallItem(title: "Year $1.27 / week", originalPrice: "$ 65.99", badge: Strings.Paywall.saveSaleText),
                        MockPaywallItem(title: "Month $1.99 / week", originalPrice: "$ 7.99", badge: nil),
                    ]
                    self.paywallView.configureMock(with: mockItems, selectedIndex: 0)
                } else {
                    self.products = products
                    let items = products.map { PaywallProductItem(product: $0) }
                    self.paywallView.configure(with: items, selectedIndex: 0)
                }
            }
        }
    }
    
    func purchase() {
        guard products.indices.contains(selectedIndex) else { return }
        paywallView.showLoading(true)
        apphud.purchase(products[selectedIndex]) { [weak self] success, error in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.paywallView.showLoading(false)
                if success {
                    self.onPurchaseSuccess?()
                    self.dismiss(animated: true)
                } else if let error {
                    self.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func restore() {
        paywallView.showLoading(true)
        apphud.restorePurchases { [weak self] success in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.paywallView.showLoading(false)
                if success {
                    self.onPurchaseSuccess?()
                    self.dismiss(animated: true)
                } else {
                    self.showError(Strings.Paywall.subscriptionsNotFoundText)
                }
            }
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: Strings.Paywall.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Paywall.okTitle, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - PaywallViewDelegate

extension PaywallViewController: PaywallViewDelegate {
    func didTapClose() {
        onClose?()
        dismiss(animated: true)
    }
    
    func didTapUnlock() {
        purchase()
    }
    
    func didTapRestore() {
        restore()
    }
    
    func didSelectProduct(at index: Int) {
        selectedIndex = index
    }
    
    func didTapPrivacy() {
        openURL(Strings.Paywall.privacyPolicyText)
    }
    
    func didTapTerms() {
        openURL(Strings.Paywall.termsUrlText)
    }
    
    private func openURL(_ string: String) {
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url)
    }
}
