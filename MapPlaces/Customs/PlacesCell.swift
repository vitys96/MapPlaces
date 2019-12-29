//
//  PlacesCell.swift
//  MapPlaces
//
//  Created by TOOK on 28.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import UIKit

class PlacesCell: UIView {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeCoordinates: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        configureUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        configureUI()
    }
    
    func configureUI() {
    }
    
    func configure(with data: Data) {
        self.placeName.text = data.placeName
        self.placeAddress.text = data.placeAddress
        self.placeCoordinates.text = data.placeCoordinates
    }
    
}

extension PlacesCell {
    struct Data {
        let placeName: String?
        let placeAddress: String?
        let placeCoordinates: String?
    }
}
