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
    
    func setGradientText(
        fullText: String,
        gradientPart: String,
        font: UIFont,
        baseColor: UIColor = .white,
        gradientColors: [UIColor]
    ) {
        let baseAttrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: baseColor
        ]
        let attributed = NSMutableAttributedString(string: fullText, attributes: baseAttrs)
        
        guard let range = fullText.range(of: gradientPart) else {
            self.attributedText = attributed
            return
        }
        let nsRange = NSRange(range, in: fullText)
        
        let size = NSAttributedString(string: fullText, attributes: [.font: font]).size()
        guard size.width > 0, size.height > 0 else {
            self.attributedText = attributed
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let gradientImage = renderer.image { ctx in
            guard let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: gradientColors.map { $0.cgColor } as CFArray,
                locations: nil
            ) else { return }
            ctx.cgContext.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: size.width, y: 0),
                options: []
            )
        }
        
        attributed.addAttribute(
            .foregroundColor,
            value: UIColor(patternImage: gradientImage),
            range: nsRange
        )
        
        self.attributedText = attributed
    }
}
