//
//  Extensions.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import Foundation

extension CGFloat {
    static func heightWithConstrainedWidth(string: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}

extension UIImageView {
    
    func blur(style: UIBlurEffectStyle = .light) {
        let effect = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(effectView)
    }
    
    func unBlur() {
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
}

extension UIView {
    func setShadow(enable: Bool, shadowOffset: CGSize = .zero, shadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), shadowRadius: CGFloat = 4, shadowOpacity: Float = 0.25, masksToBounds: Bool = false, clipsToBounds: Bool = false) {
        if enable {
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = shadowOpacity
            self.layer.masksToBounds = masksToBounds
            self.clipsToBounds = clipsToBounds
        }else {
            self.layer.shadowOffset = .zero
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 0
        }
    }
}
