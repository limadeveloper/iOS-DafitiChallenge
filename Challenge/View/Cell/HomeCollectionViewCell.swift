//
//  HomeCollectionViewCell.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet fileprivate weak var likedButton: UIButton!
    @IBOutlet private weak var imageViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelConstraintHeight: NSLayoutConstraint!
    
    private let requests = Requests()
    
    var model: Model? {
        didSet {
            
            NotificationCenter.default.addObserver(self, selector: #selector(didClickOnLikedButton(notification:)), name: Constants.NotificationObserver.Name.didClickOnLikedButton, object: nil)
            
            guard let model = model else { return }
            
            titleLabel.text = model.movie?.title?.uppercased()
            titleLabel.font = Constants.Font.bold1
            titleLabel.textColor = Constants.Color.yellow
            titleLabel.shadowColor = Constants.Color.dark
            titleLabel.shadowOffset = CGSize(width: 0, height: 5)
            
            subtitleLabel.text = model.movie?.released
            subtitleLabel.textColor = Constants.Color.yellow
            subtitleLabel.font = Constants.Font.bold2
            subtitleLabel.shadowColor = Constants.Color.dark
            subtitleLabel.shadowOffset = CGSize(width: 0, height: 3)
            
            if let photoString = model.movie?.image?.getBestImagesByWidth()?.first, let photoURL = URL(string: photoString) {
                model.movie?.image?.selectedUrl = photoURL
                imageView.af_setImage(withURL: photoURL, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            }
            
            if let text = titleLabel.text {
                let titleHeight = CGFloat.heightWithConstrainedWidth(string: text, width: titleLabel.frame.size.width, font: titleLabel.font)
                titleLabelConstraintHeight.constant = titleHeight + 12
            }
            
            updateLikedButton(by: model)
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let featuredHeight = UltraVisualLayoutConstants.Cell.featuredHeight
        let standardHeight = UltraVisualLayoutConstants.Cell.standardHeight
        
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        subtitleLabel.alpha = delta
        
        imageViewConstraintHeight.constant = featuredHeight
    }
    
    fileprivate func updateLikedButton(by model: Model?) {
    
        likedButton.setImage(nil, for: .normal)
        likedButton.tintColor = .clear
        
        if let id = model?.movie?.id?.trakt, UserDefaults.standard.bool(forKey: Constants.Persistence.Key.getKeyLike(byId: id)) {
            likedButton.setImage(#imageLiteral(resourceName: "Liked"), for: .normal)
            likedButton.tintColor = Constants.Color.liked
        }
    }
}

extension HomeCollectionViewCell {
    @objc func didClickOnLikedButton(notification: Notification) {
        updateLikedButton(by: model)
    }
}
