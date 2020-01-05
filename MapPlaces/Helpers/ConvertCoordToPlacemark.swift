//
//  ConvertCoordToPlacemark.swift
//  MapPlaces
//
//  Created by TOOK on 03.01.2020.
//  Copyright © 2020 TOOK. All rights reserved.
//

import UIKit
import MapKit

class ConvertCoordToPlacemark {
    static func lookUpCurrentLocation(touchCoordinates: CLLocationCoordinate2D, completionHandler: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: touchCoordinates.latitude, longitude: touchCoordinates.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placeMark = placemarks?.first, error == nil else {
                completionHandler(nil)
                return
            }
            var placeDescr = String()
            guard let streetName = placeMark.thoroughfare else {
                placeDescr = "Неизестно"
                return
            }
                placeDescr.append(streetName)
                if let streetNumber = placeMark.subThoroughfare {
                    placeDescr.append(", \(streetNumber)")
                }
//
//
//            let placeDescr = "\(streetName), \(streetNumber)"
            completionHandler(placeDescr)
        }
    }
}
