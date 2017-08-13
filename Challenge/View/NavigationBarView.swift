//
//  NavigationBarView.swift
//  Challenge
//
//  Created by John Lima on 11/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

protocol NavigationBarViewDelegate {
    func didClickOnDismiss(sender: UIButton)
    func didClickOnShare(sender: UIButton)
}

class NavigationBarView: UIView {

    // MARK: - Properties
    @IBOutlet fileprivate weak var backgroundImage: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var likeButton: UIButton!
    
    fileprivate var contentView: UIView?
    
    var delegate: NavigationBarViewDelegate?
    
    var model: Model? {
        didSet { updateUI() }
    }
    
    // MARK: - Struct, Enums...
    struct Size {
        static let defaultHeight: CGFloat = 64
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nibName = Constants.UI.XIB.navigationBarView
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        
        guard let contentView = contentView else { return }
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @IBAction fileprivate func dismiss(sender: UIButton) {
        delegate?.didClickOnDismiss(sender: sender)
    }
    
    @IBAction fileprivate func share(sender: UIButton) {
        delegate?.didClickOnShare(sender: sender)
    }
    
    @IBAction fileprivate func like(sender: UIButton) {
        
        guard let id = model?.movie?.id?.trakt else { return }
        
        if UserDefaults.standard.bool(forKey: Constants.Persistence.Key.getKeyLike(byId: id)) {
            UserDefaults.standard.set(false, forKey: Constants.Persistence.Key.getKeyLike(byId: id))
            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
            sender.tintColor = Constants.Color.dark
        }else {
            UserDefaults.standard.set(true, forKey: Constants.Persistence.Key.getKeyLike(byId: id))
            sender.setImage(#imageLiteral(resourceName: "Liked"), for: .normal)
            sender.tintColor = Constants.Color.liked
        }
        
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: Constants.NotificationObserver.Name.didClickOnLikedButton, object: nil)
    }
    
    fileprivate func updateUI() {
        
        contentView?.backgroundColor = .clear
        
        guard let model = model else { return }
        
        likeButton.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        likeButton.tintColor = Constants.Color.dark
        
        if let id = model.movie?.id?.trakt, UserDefaults.standard.bool(forKey: Constants.Persistence.Key.getKeyLike(byId: id)) {
            likeButton.setImage(#imageLiteral(resourceName: "Liked"), for: .normal)
            likeButton.tintColor = Constants.Color.liked
        }
        
        titleLabel.text = model.movie?.title
        titleLabel.textColor = Constants.Color.light
        titleLabel.shadowColor = Constants.Color.dark
        titleLabel.shadowOffset = CGSize(width: 0, height: 2)
        
        if let url = model.movie?.image?.selectedUrl {
            backgroundImage.af_setImage(withURL: url)
            backgroundImage.blur()
        }
    }
}
