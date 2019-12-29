//
//  AnimatedReloadAnimator.swift
//  CollectionKitTest
//
//  Created by TOOK on 05.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import Foundation
import CollectionKit


open class AnimatedReloadAnimator: Animator {
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
}
