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
//    func viewDidLoad() {
//        let items: [PlacesCell.Data] = [
//            PlacesCell.Data(placeName: "xixidid", placeAddress: "dbdndh", placeCoordinates: "cjdjdj"),
//            PlacesCell.Data(placeName: "xixidid", placeAddress: "dbdndh", placeCoordinates: "cjdjdj"),
//            PlacesCell.Data(placeName: "xixidid", placeAddress: "dbdndh", placeCoordinates: "cjdjdj"),
//            PlacesCell.Data(placeName: "xixidid", placeAddress: "dbdndh", placeCoordinates: "cjdjdj"),
//            PlacesCell.Data(placeName: "xixidid", placeAddress: "dbdndh", placeCoordinates: "cjdjdj"),
//            PlacesCell.Data(placeName: "xixidid", placeAddress: "dbdndh", placeCoordinates: "cjdjdj")
//        ]
//        self.view?.displayCollectionData(data: items)
//    }

}

// MARK: - MapScreenPresenterInterface -
extension MapScreenPresenter: MapScreenPresenterInterface {
    func mappingValues(items: [MKMapItem]) {
        let lala = items.map {
            PlacesCell.Data(placeName: $0.name, placeAddress: $0.address(), placeCoordinates: nil)
        }
        self.view?.displayCollectionData(data: lala)
    }
}

// MARK: - MapScreenInteractorOutput -
extension MapScreenPresenter: MapScreenInteractorOutput {
    
}
