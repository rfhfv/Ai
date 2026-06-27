//
//  UILabel.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

extension UILabel {
    func configureLabel(
        text: String? = nil,
        font: UIFont = Typography.r14.font,
        color: UIColor = .white,
        alignment: NSTextAlignment = .center,
        numberOfLines: Int = 0
    ) {
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
    }
}
