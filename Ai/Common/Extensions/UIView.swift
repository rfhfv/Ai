//
//  UIView.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
