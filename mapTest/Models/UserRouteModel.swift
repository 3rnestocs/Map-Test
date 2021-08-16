//
//  UserRouteModel.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/13/21.
//

import GoogleMaps

struct UserRoute: Equatable, Codable {
    static func == (lhs: UserRoute, rhs: UserRoute) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    var id: String = UUID().uuidString
    var route: [CLLocationCoordinate2D]
    var polyLines: [Polyline]
    var name: String
    var distance: Int
    var duration: String
}
