//
//  UIStack.swift
//  Ai
//
//  Created by admin on 26.06.2026.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}

