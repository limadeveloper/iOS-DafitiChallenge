//
//  CustomButton.swift
//  Challenge
//
//  Created by John Lima on 11/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
