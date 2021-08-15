//
//  UserRouteModel.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/13/21.
//

import CoreLocation

struct UserRoute {
    var id: String = UUID().uuidString
    var route: [CLLocationCoordinate2D]
    var name: String
    var distance: Int
    var duration: String
}
