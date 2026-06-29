//
//  PaywallManager .swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

final class PaywallManager {
    
    static let shared = PaywallManager()
    
    private init() {}
    
    @MainActor 
    func present(
        from viewController: UIViewController,
        onSuccess: (() -> Void)? = nil
    ) {
        guard !ApphudService.shared.isPremium else {
            onSuccess?()
            return
        }
        
        let vc = PaywallViewController()
        vc.onPurchaseSuccess = onSuccess
        vc.onClose = nil
        viewController.present(vc, animated: true)
    }
    
    @MainActor 
    @discardableResult
    func checkAccess(from viewController: UIViewController, onGranted: (() -> Void)? = nil) -> Bool {
        if ApphudService.shared.isPremium {
            onGranted?()
            return true
        }
        present(from: viewController, onSuccess: onGranted)
        return false
    }
}
