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
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var imageViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelConstraintHeight: NSLayoutConstraint!
    
    private let requests = Requests()
    
    var model: Model? {
        didSet {
            
            guard let model = model else { return }
            
            titleLabel.text = nil
            subtitleLabel.text = nil
            
            let widthPosters = model.movie?.image?.posters?.map({ $0.width ?? -1 }).filter({ $0 != -1 }).sorted(by: { Int($0) < Int($1) })
            
            var bestWidth: NSNumber {
                return 0
            }
            
            if let photoString = model.movie?.image?.posters?.filter({ $0.width == bestWidth }).first?.url, let photoURL = URL(string: photoString) {
                imageView.af_setImage(withURL: photoURL, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            }
            
            if let text = titleLabel.text {
                let titleHeight = CGFloat.heightWithConstrainedWidth(string: text, width: titleLabel.frame.size.width, font: titleLabel.font)
                titleLabelConstraintHeight.constant = titleHeight + 12
            }
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
}
