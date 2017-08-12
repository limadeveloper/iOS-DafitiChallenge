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
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet fileprivate weak var labelError: UILabel!
    @IBOutlet fileprivate weak var viewError: UIView!
    @IBOutlet fileprivate weak var webView: UIWebView!
    @IBOutlet fileprivate weak var heightConstraintWebView: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topConstraintNavigationView: NSLayoutConstraint!
    
    var model: Model?
    var lastControllerRotationStatus: Bool?
    
    // MARK: - Structs, Enums...
    struct Constraint {
        static let topNavigationViewIsHidden: CGFloat = 64
        static let topNavigationViewIsShow: CGFloat = 0
    }
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        
        if height < width { // landscape
            loadWebView(withHeight: height)
        }else { // portrait
            loadWebView()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            isPortrait()
        }else if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            isLandscape()
        }
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
        navigationBarView.setShadow(enable: true, shadowOpacity: 0.40)
        navigationBarView.delegate = self
        
        navigationView.addSubview(navigationBarView)
        
        tapGesture.addTarget(self, action: #selector(tapOnLabelError))
        labelError.addGestureRecognizer(tapGesture)
        
        viewError.layer.cornerRadius = 3
        
        hideError()
        
        loadWebView()
    }
    
    fileprivate func loadWebView(withHeight: CGFloat? = nil) {
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = true
        webView.delegate = self
        
        let width = view.frame.size.width
        let height = (width/320) * 275
        
        heightConstraintWebView.constant = withHeight ?? height
        
        guard let stringUrl = model?.movie?.trailerUrl, let url = URL(string: stringUrl) else { return }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }
    
    fileprivate func hideError(isHidden: Bool = true) {
        viewError.isHidden = isHidden
        labelError.isHidden = isHidden
    }
    
    fileprivate func isPortrait() {
        UIView.animate(withDuration: 0.5) { 
            self.topConstraintNavigationView.constant = Constraint.topNavigationViewIsShow
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func isLandscape() {
        UIView.animate(withDuration: 0.5) {
            self.topConstraintNavigationView.constant = Constraint.topNavigationViewIsHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func tapOnLabelError() {
        loadWebView()
    }
}

extension DetailsViewController: NavigationBarViewDelegate {
    func didClickOnDismiss(sender: UIButton) {
        dismiss(animated: true) {
            self.webView.stopLoading()
        }
    }
}

extension DetailsViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
        hideError()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        hideError(isHidden: false)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        hideError()
    }
}
