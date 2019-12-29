//
//  CollectionInsidable.swift
//  CollectionKitTest
//
//  Created by TOOK on 05.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import Foundation
import UIKit
import CollectionKit
protocol CollectionInsidable  {
    var collectionHeight: CGFloat? {get}
    var layoutInsets: UIEdgeInsets {get}
    var isPagingEnabled: Bool {get}
    var needPageControl: Bool {get}
    var isBouncingEnabled: Bool {get}
    var zPosition: CGFloat {get}
    
    func insideCollection() -> CollectionInsideProvider
}
extension CollectionInsidable where Self: Provider {
    var layoutInsets: UIEdgeInsets {
        return .zero
    }
    func insideCollection() -> CollectionInsideProvider {
        let collectionProvider = CollectionInsideProvider(self, height: collectionHeight, isPagingEnabled: isPagingEnabled, needPageControl: needPageControl, isBouncingEnabled: isBouncingEnabled, zPosition: zPosition)
        collectionProvider.layout = FlowLayout().inset(by: layoutInsets)
        return collectionProvider
    }
}
