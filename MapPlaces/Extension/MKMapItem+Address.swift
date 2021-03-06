//
//  MKMapItem+Address.swift
//  MapPlaces
//
//  Created by TOOK on 28.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import MapKit

extension MKMapItem {
    func address() -> String {
        var addressString = ""
        if placemark.subThoroughfare != nil {
            addressString = placemark.subThoroughfare! + " "
        }
        if placemark.thoroughfare != nil {
            addressString += placemark.thoroughfare! + ", "
        }
        if placemark.postalCode != nil {
            addressString += placemark.postalCode! + " "
        }
        if placemark.locality != nil {
            addressString += placemark.locality! + ", "
        }
        if placemark.administrativeArea != nil {
            addressString += placemark.administrativeArea! + " "
        }
        if placemark.country != nil {
            addressString += placemark.country!
        }
        return addressString
    }
    
    func coordinates() -> String {
        let lat = placemark.coordinate.latitude
        let long = placemark.coordinate.longitude
        let formattedLat = String(format: "%.6f", lat)
        let formattedLong = String(format: "%.6f", long)
        let fullCoordinates = "\(formattedLat) \(formattedLong)"
        
        return fullCoordinates
    }
}
