//
//  CLLocationCoordinate2D.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/15/21.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        if lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude {
            return true
        } else {
            return false
        }
    }
}
