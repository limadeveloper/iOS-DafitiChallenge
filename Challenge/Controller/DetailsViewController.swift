//
//  DetailsViewController.swift
//  Challenge
//
//  Created by John Lima on 11/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet fileprivate weak var navigationView: UIView!
    @IBOutlet fileprivate weak var backgroundImage: UIImageView!
    @IBOutlet fileprivate weak var webView: UIWebView!
    @IBOutlet fileprivate weak var heightConstraintWebView: NSLayoutConstraint!
    
    var model: Model?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        heightConstraintWebView.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadWebView()
    }
    
    // MARK: - Actions
    fileprivate func updateUI() {
        
        if let url = model?.movie?.image?.selectedUrl {
            backgroundImage.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        }
        
        backgroundImage.blur()
        
        let navigationBarView = NavigationBarView(frame: navigationView.bounds)
        navigationBarView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationBarView.backgroundColor = .clear
        navigationBarView.model = model
        navigationBarView.setShadow(enable: true)
        navigationBarView.delegate = self
        
        navigationView.addSubview(navigationBarView)
    }
    
    fileprivate func loadWebView() {
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        
        let width = view.frame.size.width
        let height = (width/320) * 275
        
        heightConstraintWebView.constant = height
        
        guard let stringUrl = model?.movie?.trailerUrl, let url = URL(string: stringUrl) else { return }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }
}

extension DetailsViewController: NavigationBarViewDelegate {
    func didClickOnDismiss(sender: UIButton) {
        dismiss(animated: true) {
            self.webView.stopLoading()
        }
    }
}
