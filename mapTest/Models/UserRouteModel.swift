//
//  UserRouteModel.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/13/21.
//

import GoogleMaps

struct UserRoute: Codable {
    var id: String = UUID().uuidString
    var route: [CLLocationCoordinate2D]
    var polyLine: Polyline
    var name: String
    var distance: Int
    var duration: String
}
