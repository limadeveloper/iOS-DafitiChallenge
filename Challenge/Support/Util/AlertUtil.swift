//
//  AlertUtil.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import Foundation

struct AlertUtil {
    
    static func showAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction], style: UIAlertControllerStyle = .alert, target: AnyObject) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions {
            controller.addAction(action)
        }
        
        DispatchQueue.main.async {
            target.present(controller, animated: true, completion: nil)
        }
    }
}
