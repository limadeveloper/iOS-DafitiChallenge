//
//  DetailsViewController.swift
//  Challenge
//
//  Created by John Lima on 11/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var object: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Movie: \(object?.movie?.title ?? "---")")
    }
    
    @IBAction fileprivate func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
