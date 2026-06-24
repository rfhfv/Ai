//
//  Typography.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

enum Typography {
    case smallR, smallM, smallB, mediumR, mediumM, mediumB, bigR, bigM, bigB, largeR, largeM, largeB, hugeR, hugeM, hugeB, hugeTitleB
    
    var font: UIFont {
        switch self {
        case .smallR: return .systemFont(ofSize: 12, weight: .regular)
        case .smallM: return .systemFont(ofSize: 12, weight: .medium)
        case .smallB: return .systemFont(ofSize: 12, weight: .bold)
        case .mediumR: return .systemFont(ofSize: 14, weight: .regular)
        case .mediumM: return .systemFont(ofSize: 14, weight: .medium)
        case .mediumB: return .systemFont(ofSize: 14, weight: .bold)
        case .bigR: return .systemFont(ofSize: 16, weight: .regular)
        case .bigM: return .systemFont(ofSize: 16, weight: .medium)
        case .bigB: return .systemFont(ofSize: 16, weight: .bold)
        case .largeR: return .systemFont(ofSize: 20, weight: .regular)
        case .largeM: return .systemFont(ofSize: 20, weight: .medium)
        case .largeB: return .systemFont(ofSize: 20, weight: .bold)
        case .hugeR: return .systemFont(ofSize: 24, weight: .regular)
        case .hugeM: return .systemFont(ofSize: 24, weight: .medium)
        case .hugeB: return .systemFont(ofSize: 24, weight: .bold)
        case .hugeTitleB: return .systemFont(ofSize: 28, weight: .bold)
        }
    }
}
