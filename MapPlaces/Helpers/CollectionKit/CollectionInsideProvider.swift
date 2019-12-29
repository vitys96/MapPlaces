//
//  CollectionInsideProvider.swift
//  CollectionKitTest
//
//  Created by TOOK on 05.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import UIKit
import CollectionKit
import CHIPageControl

class CollectionInsideProvider: BasicProvider<Provider, CollectionCell> {
    init(_ provider: Provider, height: CGFloat?, isPagingEnabled: Bool, needPageControl: Bool, isBouncingEnabled: Bool, zPosition: CGFloat) {
        let sourceSize = ClosureSizeSource {(index: Int, data: Provider, collectionSize: CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: height ?? collectionSize.height)
        }
        
        let sourceView = ClosureViewSource(viewUpdater: {(cell: CollectionCell, data: Provider, index: Int) in
            cell.configure(with: data, needPageControl: needPageControl, zPosition: zPosition)
            cell.collectionView.isPagingEnabled = isPagingEnabled
            cell.collectionView.bounces = isBouncingEnabled
        })
    
        super.init(
            dataSource: ArrayDataSource(data: [provider]),
            viewSource: sourceView,
            sizeSource: sourceSize
        )
    }
}
