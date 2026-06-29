//
//  PaywallProductItem.swift
//  Ai
//
//  Created by admin on 29.06.2026.
//

import UIKit
import ApphudSDK
import StoreKit

struct PaywallProductItem {
    let title: String
    let originalPrice: String?
    let badge: String?
    let product: ApphudProduct
    
    init(product: ApphudProduct) {
        self.product = product
        
        guard let skProduct = product.skProduct else {
            title = ""
            originalPrice = nil
            badge = nil
            return
        }
        
        let formatted = PaywallProductItem.format(skProduct)
        title = formatted.title
        originalPrice = formatted.originalPrice
        badge = formatted.badge
    }
}

// MARK: - Private Formatting

private extension PaywallProductItem {
    
    struct Formatted {
        let title: String
        let originalPrice: String?
        let badge: String?
    }
    
    static func format(_ skProduct: SKProduct) -> Formatted {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = skProduct.priceLocale
        
        let price = skProduct.price.doubleValue
        let formattedPrice = formatter.string(from: skProduct.price) ?? "$\(price)"
        
        switch skProduct.subscriptionPeriod?.unit {
        case .year:
            let weeklyPrice = price / 52
            let formattedWeekly = formatter.string(from: NSNumber(value: weeklyPrice))
            ?? String(format: "$%.2f", weeklyPrice)
            return Formatted(
                title: "Year \(formattedWeekly) / week",
                originalPrice: formattedPrice,
                badge: Strings.Paywall.saveSaleText
            )
        default:
            return Formatted(
                title: "Month \(formattedPrice) / week",
                originalPrice: formattedPrice,
                badge: nil
            )
        }
    }
}
