//
//  GalleryViewController.swift
//  Challenge
//
//  Created by John Lima on 12/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

class GalleryViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    fileprivate var imageView = UIImageView()
    
    var selectedImageUrl: String?
    var lastControllerRotationStatus: Bool?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layoutIfNeeded()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.shouldRotate = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.shouldRotate = lastControllerRotationStatus ?? false
        }
    }
    
    // MARK: - Actions
    @IBAction fileprivate func dismiss(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func updateUI() {
        
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let stringUrl = selectedImageUrl, let url = URL(string: stringUrl) {
            imageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            backgroundImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        }
        
        backgroundImageView.blur()
        
        scrollView.addSubview(imageView)
        scrollView.setContentOffset(.zero, animated: true)
    }
}

extension GalleryViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
