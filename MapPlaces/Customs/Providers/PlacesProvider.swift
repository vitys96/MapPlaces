//
//  PlacesProvider.swift
//  MapPlaces
//
//  Created by TOOK on 28.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import UIKit
import CollectionKit

class PlacesProvider: BasicProvider<PlacesCell.Data, PlacesCell> {
    init(_ dataSource: DataSource<PlacesCell.Data>, tapHandler: ((PlacesProvider.TapContext)->(Void))? = nil) {
        let sourceSize = ClosureSizeSource {(index: Int, data: PlacesCell.Data, collectionSize: CGSize) -> CGSize in
            return CGSize(width: collectionSize.width - CGFloat(64).dp, height: collectionSize.height)
        }
        let sourceView = ClosureViewSource(viewUpdater: {(cell: PlacesCell, data: PlacesCell.Data, index: Int) in
            cell.configure(with: data)
            cell.subviews.first?.clipsToBounds = true
            cell.subviews.first?.layer.cornerRadius = 10
            cell.subviews.first?.setGradientBackground(colorOne: .hexStringToUIColor(hex: "d4e2fa"),
                                                       colorTwo: .white)
            cell.clipsToBounds = false
            cell.applyStandardShadow()
        })
        
        let layout: CollectionKit.Layout
        let spacing: CGFloat = 16
        let inset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layout = RowLayout(spacing: spacing).insetVisibleFrame(by: UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16))
            .inset(by: inset)
        
        super.init(
            dataSource: dataSource,
            viewSource: sourceView,
            sizeSource: sourceSize,
            layout: layout,
            animator: AnimatedReloadAnimator(entryTransform: AnimatedReloadAnimator.fancyEntryTransform),
            tapHandler: tapHandler
        )
    }
}

extension CollectionView {
    func scroll(to index: Int, animated: Bool) {
        guard self.provider as? ComposedProvider == nil else {
            return
        }
        guard let provider = self.provider else {
            return
        }
        let itemFrame = provider.frame(at: index)
        var targetPoint = CGPoint(x: itemFrame.origin.x - 8, y: itemFrame.origin.y)
        let itemXDiff = self.contentSize.width - itemFrame.origin.x
        let itemYDiff = self.contentSize.height - itemFrame.origin.y
        if itemXDiff < self.visibleFrame.width || itemYDiff < self.visibleFrame.height {
            targetPoint = CGPoint(x: self.contentSize.width - self.visibleFrame.width, y: self.contentSize.height - self.visibleFrame.height)
        }
        setContentOffset(targetPoint, animated: animated)
        
    }

}
