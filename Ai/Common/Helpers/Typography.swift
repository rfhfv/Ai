//
//  Typography.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

enum Typography {
    case r12, m12, b12, r14, m14, b14, r16, m16, b16, r20, m20, b20, r24, m24, b24, b28
    
    var font: UIFont {
        switch self {
        case .r12: return .systemFont(ofSize: 12, weight: .regular)
        case .m12: return .systemFont(ofSize: 12, weight: .medium)
        case .b12: return .systemFont(ofSize: 12, weight: .bold)
        case .r14: return .systemFont(ofSize: 14, weight: .regular)
        case .m14: return .systemFont(ofSize: 14, weight: .medium)
        case .b14: return .systemFont(ofSize: 14, weight: .bold)
        case .r16: return .systemFont(ofSize: 16, weight: .regular)
        case .m16: return .systemFont(ofSize: 16, weight: .medium)
        case .b16: return .systemFont(ofSize: 16, weight: .bold)
        case .r20: return .systemFont(ofSize: 20, weight: .regular)
        case .m20: return .systemFont(ofSize: 20, weight: .medium)
        case .b20: return .systemFont(ofSize: 20, weight: .bold)
        case .r24: return .systemFont(ofSize: 24, weight: .regular)
        case .m24: return .systemFont(ofSize: 24, weight: .medium)
        case .b24: return .systemFont(ofSize: 24, weight: .bold)
        case .b28: return .systemFont(ofSize: 28, weight: .bold)
        }
    }
}
