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
    
    var model: Model?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
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
    
    fileprivate func loadWebView() {
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = true
        webView.delegate = self
        
        let width = view.frame.size.width
        let height = (width/320) * 275
        
        heightConstraintWebView.constant = height
        
        guard let stringUrl = model?.movie?.trailerUrl, let url = URL(string: stringUrl) else { return }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }
    
    fileprivate func hideError(isHidden: Bool = true) {
        viewError.isHidden = isHidden
        labelError.isHidden = isHidden
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
