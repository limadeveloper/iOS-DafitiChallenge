//
//  GridCollectionViewCell.swift
//  Challenge
//
//  Created by John Lima on 14/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var likedButton: UIButton!
    
    var model: Model? {
        didSet {
            
            NotificationCenter.default.addObserver(self, selector: #selector(didClickOnLikedButton(notification:)), name: Constants.NotificationObserver.Name.didClickOnLikedButton, object: nil)
            
            guard let model = model else { return }
            
            titleLabel.text = model.movie?.title?.uppercased()
            titleLabel.font = Constants.Font.bold2
            titleLabel.textColor = Constants.Color.yellow
            titleLabel.shadowColor = Constants.Color.dark
            titleLabel.shadowOffset = CGSize(width: 0, height: 1)
            
            imageView.image = #imageLiteral(resourceName: "Placeholder")
            backgroundImageView.image = #imageLiteral(resourceName: "Placeholder")
            backgroundImageView.blur()
            
            if let photoString = model.movie?.image?.getBestImagesByWidth()?.first, let photoURL = URL(string: photoString) {
                model.movie?.image?.selectedUrl = photoURL
                imageView.af_setImage(withURL: photoURL, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
                backgroundImageView.af_setImage(withURL: photoURL, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            }
            
            updateLikedButton(by: model)
        }
    }
    
    fileprivate func updateLikedButton(by model: Model?) {
        
        likedButton.setImage(nil, for: .normal)
        likedButton.tintColor = .clear
        
        if let id = model?.movie?.id?.trakt, UserDefaults.standard.bool(forKey: Constants.Persistence.Key.getKeyLike(byId: id)) {
            likedButton.setImage(#imageLiteral(resourceName: "Liked"), for: .normal)
            likedButton.tintColor = Constants.Color.liked
        }
    }
    
    @objc func didClickOnLikedButton(notification: Notification) {
        updateLikedButton(by: model)
    }
}
