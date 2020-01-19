//
//  AnimatedReloadAnimator.swift
//  CollectionKitTest
//
//  Created by TOOK on 05.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import UIKit
import CollectionKit


class AnimatedReloadAnimator: Animator {
    static let defaultEntryTransform: CATransform3D = CATransform3DTranslate(CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 1), 0, 0, -1)
    static let fancyEntryTransform: CATransform3D = {
        var trans = CATransform3DIdentity
        trans.m34 = -1 / 500
        return CATransform3DScale(CATransform3DRotate(CATransform3DTranslate(trans, 0, -50, -100), 0.5, 1, 0, 0), 0.8, 0.8, 1)
    }()
    
    let entryTransform: CATransform3D
    
    init(entryTransform: CATransform3D = defaultEntryTransform) {
        self.entryTransform = entryTransform
        super.init()
    }
    override func delete(collectionView: CollectionView, view: UIView) {
      if collectionView.isReloading, collectionView.bounds.intersects(view.frame) {
        UIView.animate(withDuration: 0.25, animations: {
          view.layer.transform = self.entryTransform
          view.alpha = 0
        }, completion: { _ in
          if !collectionView.visibleCells.contains(view) {
            view.recycleForCollectionKitReuse()
            view.transform = CGAffineTransform.identity
            view.alpha = 1
          }
        })
      } else {
        view.recycleForCollectionKitReuse()
      }
    }

    override func insert(collectionView: CollectionView, view: UIView, at: Int, frame: CGRect) {
      view.bounds = frame.bounds
      view.center = frame.center
      if collectionView.isReloading, collectionView.hasReloaded, collectionView.bounds.intersects(frame) {
        let offsetTime: TimeInterval = TimeInterval(frame.origin.distance(collectionView.contentOffset) / 3000)
        view.layer.transform = entryTransform
        view.alpha = 0
        UIView.animate(withDuration: 0.5, delay: offsetTime, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
          view.transform = .identity
          view.alpha = 1
        })
      }
    }

    override func update(collectionView: CollectionView, view: UIView, at: Int, frame: CGRect) {
      if view.center != frame.center {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.layoutSubviews], animations: {
          view.center = frame.center
        }, completion: nil)
      }
      if view.bounds.size != frame.bounds.size {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.layoutSubviews], animations: {
          view.bounds.size = frame.bounds.size
        }, completion: nil)
      }
      if view.alpha != 1 || view.transform != .identity {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
          view.transform = .identity
          view.alpha = 1
        }, completion: nil)
      }
    }
}

