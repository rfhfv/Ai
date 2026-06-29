//
//  ApphudService.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import Foundation
import ApphudSDK

protocol ApphudServiceProtocol {
    var isPremium: Bool { get }
    func start()
    func fetchPaywall(completion: @escaping ([ApphudProduct]) -> Void)
    func purchase(_ product: ApphudProduct, completion: @escaping (Bool, Error?) -> Void)
    func restorePurchases(completion: @escaping (Bool) -> Void)
}

// MARK: - Service

final class ApphudService: ApphudServiceProtocol {
    
    static let shared = ApphudService()
    
    private init() {}
    
    private enum Config {
        static let apiKey: String = {
            Bundle.main.object(forInfoDictionaryKey: "APPHUD_API_KEY") as? String ?? ""
        }()
        
        static let paywallId = "main"
    }
    
    // MARK: - Public
    
    @MainActor
    var isPremium: Bool {
        Apphud.hasPremiumAccess()
    }
    
    @MainActor
    func start() {
        Apphud.start(apiKey: Config.apiKey)
    }
    
    @MainActor
    func fetchPaywall(completion: @escaping ([ApphudProduct]) -> Void) {
        var didComplete = false
        
        let complete: ([ApphudProduct]) -> Void = { products in
            guard !didComplete else { return }
            didComplete = true
            DispatchQueue.main.async { completion(products) }
        }
        
        Apphud.paywallsDidLoadCallback { paywalls in
            guard let paywall = paywalls.first(where: { $0.identifier == Config.paywallId }) else {
                complete([])
                return
            }
            let valid = paywall.products.filter { $0.skProduct != nil }
            valid.isEmpty ? complete([]) : complete(valid)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            complete([])
        }
    }
    
    @MainActor
    func purchase(_ product: ApphudProduct, completion: @escaping (Bool, Error?) -> Void) {
        Apphud.purchase(product) { result in
            if let error = result.error {
                completion(false, error)
                return
            }
            completion(result.success, nil)
        }
    }
    
    @MainActor
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        Apphud.restorePurchases { subscriptions, _, error in
            if error != nil {
                completion(false)
                return
            }
            let hasActive = subscriptions?.contains { $0.isActive() } ?? false
            completion(hasActive || Apphud.hasPremiumAccess())
        }
    }
}
