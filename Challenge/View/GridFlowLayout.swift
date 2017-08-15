//
//  GridFlowLayout.swift
//  Challenge
//
//  Created by John Lima on 14/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class GridFlowLayout: UICollectionViewFlowLayout {

    let itemHeight: CGFloat = 245
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    /// Sets up the layout for the collectionView. 0 distance between each cell, and vertical layout
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.width/3)-1
    }
    
    override var itemSize: CGSize {
        set { self.itemSize = CGSize(width: itemWidth(), height: itemHeight) }
        get { return CGSize(width: itemWidth(), height: itemHeight) }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
