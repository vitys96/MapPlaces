//
//  CollectionCell.swift
//  CollectionKitTest
//
//  Created by TOOK on 05.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import UIKit
import CollectionKit
import CHIPageControl

class CollectionCell: UIView {
    var collectionView: CollectionView = CollectionView()
    let pageControl = CHIPageControlPaprika()
    var previousContentOffset: CGPoint = CGPoint.zero
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: .zero)
        addSubview(collectionView)
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.fillSuperview()
        addSubview(pageControl)
        pageControl.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: 20)
//        pageControl.anchorCenterXToSuperview()
        pageControl.radius = 3
        pageControl.backgroundColor = .clear
        pageControl.tintColor = UIColor.lightGray
        pageControl.currentPageTintColor = .yellow
        collectionView.delegate = self
    }
    
    func configure(with provider: Provider, needPageControl: Bool, zPosition: CGFloat) {
        collectionView.provider = provider
        self.layer.zPosition = zPosition
        pageControl.isHidden = !needPageControl
        if needPageControl {
            pageControl.numberOfPages = provider.numberOfItems
            var visibleFrame = frame
            visibleFrame.origin.x = collectionView.contentOffset.x
            pageControl.progress = Double(provider.visibleIndexes(visibleFrame: visibleFrame).first ?? 0)
        }
        
    }
}

extension CollectionCell: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = Double((scrollView.contentOffset.x) / (scrollView.frame.width))
        pageControl.progress = progress
    }
}
