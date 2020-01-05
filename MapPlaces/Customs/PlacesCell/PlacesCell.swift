//
//  PlacesCell.swift
//  MapPlaces
//
//  Created by TOOK on 28.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import UIKit
import SPAlert

class PlacesCell: UIView {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeCoordinates: UILabel!
    @IBOutlet var contentView: UIView!
    
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
        placeName.numberOfLines = 0
        placeAddress.numberOfLines = 0
        
        if #available(iOS 13.0, *) {
            let interaction = UIContextMenuInteraction(delegate: self)
            contentView.addInteraction(interaction)
        }
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

// MARK: - UIContextMenuInteractionDelegate
@available(iOS 13.0, *)
extension PlacesCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let share = UIAction(title: "Скопировать адрес", image: UIImage(systemName: "square.and.arrow.up")) {[weak self] (action) in
                guard let self = self else { return }
                UIPasteboard.general.string = self.placeAddress.text
                let alertView = SPAlertView(title: "Скопировано", message: nil, preset: SPAlertPreset.done)
                alertView.duration = 0.5
                alertView.dismissByTap = false
                alertView.haptic = .success
                alertView.present()
            }
            
            let open = UIAction(title: "Открыть в картах", image: UIImage(systemName: "square.and.arrow.up")) {[weak self] (action) in
                guard let self = self else { return }
                let lat = self.placeCoordinates.text
                if let components = lat?.split(separator: " ") {
                    if let url = URL(string: "yandexmaps://maps.yandex.ru/?pt=\(components[1]),\(components[0])&z=18&l=map") {
                        UIApplication.shared.open(url)
                        print (url)
                    }
                }
            }
            
            return UIMenu(title: "", children: [share, open])
        }
        return configuration
    }
}
