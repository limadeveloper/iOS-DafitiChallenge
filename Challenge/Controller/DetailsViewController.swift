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
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var detailsTextLabel: UILabel!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var heightConstraintWebView: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topConstraintNavigationView: NSLayoutConstraint!
    @IBOutlet fileprivate weak var heightConstraintDetailsTextLabel: NSLayoutConstraint!
    @IBOutlet fileprivate weak var heightConstraintContentGalleryView: NSLayoutConstraint!
    @IBOutlet fileprivate weak var heightConstraintGalleryLabel: NSLayoutConstraint!
    
    fileprivate var gallery = [String]()
    fileprivate let cellName = "cell"
    fileprivate var shareActivityVC: UIActivityViewController?
    
    var model: Model?
    var selectedImage: UIImage?
    var lastControllerRotationStatus: Bool?
    
    // MARK: - Structs, Enums...
    struct Constraint {
        static let topNavigationViewIsHidden: CGFloat = 64
        static let topNavigationViewIsShow: CGFloat = 0
        static let spaceBetweenItemsInScrollView: CGFloat = 20
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
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
        
        guard UIDevice.current.userInterfaceIdiom != .pad else { return }
        
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        
        if height < width { // landscape
            loadWebView(withHeight: height)
        }else { // portrait
            loadWebView()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard UIDevice.current.userInterfaceIdiom != .pad else {
            shareActivityVC?.dismiss(animated: true, completion: nil);
            return
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            isPortrait()
        }else if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            isLandscape()
        }
    }
    
    // MARK: - Actions
    fileprivate func updateUI() {
        
        backgroundImage.image = #imageLiteral(resourceName: "Placeholder")
        
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
        setupDetailsTextLabel()
        setupScrollView()
        loadWebView()
        
        collectionView.reloadData()
    }
    
    fileprivate func getData() {
        gallery = model?.movie?.image?.backdrops?.map({ $0.url ?? "-" }).filter({ $0 != "-" }) ?? []
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
    
    fileprivate func setupDetailsTextLabel() {
    
        let keyAttributes = [NSFontAttributeName: Constants.Font.medium1!, NSForegroundColorAttributeName: Constants.Color.light]
        let valueAttributes = [NSFontAttributeName: Constants.Font.medium1!, NSForegroundColorAttributeName: Constants.Color.yellow]
        
        let rating = String.localizedStringWithFormat("%.2f", model?.movie?.rating as? Double ?? 0)
        let genres = (model?.movie?.genres ?? []).joined(separator: ", ")
        
        let key1 = NSMutableAttributedString(string: "\(Constants.Text.releaseDate): ", attributes: keyAttributes)
        let value1 = NSAttributedString(string: "\(model?.movie?.released ?? "---")\n", attributes: valueAttributes)
        let key2 = NSAttributedString(string: "\(Constants.Text.runtime): ", attributes: keyAttributes)
        let value2 = NSAttributedString(string: "\(model?.movie?.runtime ?? 0)\n", attributes: valueAttributes)
        let key3 = NSAttributedString(string: "\(Constants.Text.rating): ", attributes: keyAttributes)
        let value3 = NSAttributedString(string: "\(rating)\n", attributes: valueAttributes)
        let key4 = NSAttributedString(string: "\(Constants.Text.tagline): ", attributes: keyAttributes)
        let value4 = NSAttributedString(string: "\(model?.movie?.tagline ?? "---")\n", attributes: valueAttributes)
        let key5 = NSAttributedString(string: "\(Constants.Text.genres): ", attributes: keyAttributes)
        let value5 = NSAttributedString(string: "\(genres)\n\n", attributes: valueAttributes)
        let key6 = NSAttributedString(string: "\(Constants.Text.overview): ", attributes: keyAttributes)
        let value6 = NSAttributedString(string: "\(model?.movie?.overview ?? "---")", attributes: valueAttributes)
        
        key1.append(value1)
        key1.append(key2)
        key1.append(value2)
        key1.append(key3)
        key1.append(value3)
        key1.append(key4)
        key1.append(value4)
        key1.append(key5)
        key1.append(value5)
        key1.append(key6)
        key1.append(value6)
        
        detailsTextLabel.attributedText = key1
        heightConstraintDetailsTextLabel.constant = CGFloat.heightWithConstrainedWidth(string: detailsTextLabel.text ?? "---", width: detailsTextLabel.bounds.width, font: Constants.Font.medium1!) + 50
    }
    
    fileprivate func setupScrollView() {
        scrollView.contentSize = CGSize(width: 0, height: heightConstraintDetailsTextLabel.constant + heightConstraintContentGalleryView.constant + heightConstraintGalleryLabel.constant + (3 * Constraint.spaceBetweenItemsInScrollView + 8))
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
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
    
    func didClickOnShare(sender: UIButton) {
        
        let trailerUrl = model?.movie?.trailerUrl ?? ""
        let text = "\(model?.movie?.title ?? "")\n\(trailerUrl)"
        var itemsToShare: [Any] = [text]
        
        if let selectedImage = selectedImage {
            itemsToShare = [text, selectedImage]
        }
        
        shareActivityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            let x = view.frame.size.width / 2
            let y = view.frame.size.height / 2.8
            let width = CGFloat(0)
            let height = width
            
            shareActivityVC?.popoverPresentationController?.sourceView = view
            shareActivityVC?.popoverPresentationController?.sourceRect = CGRect(x: x, y: y, width: width, height: height)
            shareActivityVC?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        if let shareActivity = shareActivityVC {
            present(shareActivity, animated: true, completion: nil)
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

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        let imageView = cell.viewWithTag(1) as? UIImageView
        
        if let url = URL(string: gallery[indexPath.item]) {
            imageView?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.UI.Storyboard.Segue.gallery, sender: indexPath)
    }
}

extension DetailsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case Constants.UI.Storyboard.Segue.gallery:
            guard let indexPath = sender as? IndexPath else { return }
            let controller = segue.destination as? GalleryViewController
            controller?.selectedImageUrl = gallery[indexPath.item]
        default:
            break
        }
    }
}
