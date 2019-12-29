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
            return CGSize(width: collectionSize.width - CGFloat(60).dp, height: collectionSize.height)
            
        }
        let sourceView = ClosureViewSource(viewUpdater: {(cell: PlacesCell, data: PlacesCell.Data, index: Int) in
            cell.configure(with: data)
            cell.subviews.first?.clipsToBounds = true
            cell.subviews.first?.layer.cornerRadius = 10
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
            animator: AnimatedReloadAnimator(),
            tapHandler: tapHandler
        )
    }
}
