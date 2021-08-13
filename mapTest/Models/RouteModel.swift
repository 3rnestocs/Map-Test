//
//  RouteModel.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/12/21.
//

import Foundation

// MARK: - Welcome
struct RouteResponse: Codable {
    var routes: [Route]
    var status: String

    enum CodingKeys: String, CodingKey {
        case routes, status
    }
}

// MARK: - Route
struct Route: Codable {
    var overviewPolyline: Polyline?
    var legs: [Leg]
    enum CodingKeys: String, CodingKey {
        case legs
        case overviewPolyline = "overview_polyline"
    }
}

// MARK: - Polyline
struct Polyline: Codable {
    var points: String
}

// MARK: - Leg
struct Leg: Codable {
    var duration, distance: Amount
    var startAddress, endAddress: String
    var startLocation, endLocation: Location
    var steps: [Step]
    enum CodingKeys: String, CodingKey {
        case duration, distance, steps
        case startAddress = "start_address"
        case endAddress = "end_address"
        case startLocation = "start_location"
        case endLocation = "end_location"
    }
}

// MARK: - Distance
struct Amount: Codable {
    var value: Int
    var text: String
}

// MARK: - Step
struct Step: Codable {
    var duration: Amount
    var distance: Amount
    var polyline: Polyline
    var startLocation, endLocation: Location

    enum CodingKeys: String, CodingKey {
        case duration, distance, polyline
        case startLocation = "start_location"
        case endLocation = "end_location"
    }
}

// MARK: - Location
struct Location: Codable {
    var lat, lng: Double
}
