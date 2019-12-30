//
//  MapScreenPresenter.swift
//  MapPlaces
//
//  Created TOOK on 27.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//
//  Template generated by Sakhabaev Egor @Banck
//  https://github.com/Banck/Swift-viper-template-for-xcode
//

import UIKit
import MapKit

class MapScreenPresenter {
    // MARK: - Properties
    weak private var view: MapScreenView?
    var interactor: MapScreenInteractorInput?
    private let router: MapScreenWireframeInterface

    // MARK: - Initialization and deinitialization -
    init(interface: MapScreenView, interactor: MapScreenInteractorInput?, router: MapScreenWireframeInterface) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}

// MARK: - MapScreenPresenterInterface -
extension MapScreenPresenter: MapScreenPresenterInterface {
    func mappingValues(items: [MKMapItem]) {
        let collectionData = items.map { place -> PlacesCell.Data in
//            let lat = place.placemark.coordinate.latitude
//            let long = place.placemark.coordinate.longitude
            return PlacesCell.Data(placeName: place.name, placeAddress: place.address(), placeCoordinates: place.coordinates())
        }
        self.view?.displayCollectionData(data: collectionData)
    }
}

// MARK: - MapScreenInteractorOutput -
extension MapScreenPresenter: MapScreenInteractorOutput {
    
}

