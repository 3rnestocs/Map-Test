//
//  MapViewModel.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/12/21.
//

import Foundation
import GoogleMaps

protocol MapViewModelType: class {
    func getLocations() -> [CLLocationCoordinate2D]
    func drawRouteOnMap()
}

class MapViewModel: MapViewModelType {
    weak var delegate: MapViewControllerDelegate?
    private var mapViewController: MapViewController!
    private let locationManager = LocationManager()
    private var locations: [CLLocationCoordinate2D]?
    private var routes: [Route]?

    init(viewController: MapViewController) {
        self.mapViewController = viewController
        self.setupLocation()
    }

    private func setupLocation() {
        locationManager.delegate = self
        locationManager.getCurrentLocation()
    }

    private func updateMap(locations: [CLLocationCoordinate2D]) {
        if let mapVC = self.mapViewController {
            mapVC.focusUserLocation(userLocation: locations[0])
            mapVC.setupMarkers(source: locations[0], destination: locations[1])
        }
    }

    func fetchRoutes() {
        ApiClient.shared.requestPlaces(locations: getLocations(), completion: { result in
            switch result {
            case .success(let routes):
                self.routes = routes
                self.delegate?.routeDrawingSuccess()
            case .failure(let error):
                print("Map error:", error)
                self.delegate?.routeDrawingFailure()
            }
        })
    }

    func getLocations() -> [CLLocationCoordinate2D] {
        guard let locations = self.locations else { return
            [CLLocationCoordinate2D]()
        }
        return locations
    }

    func drawRouteOnMap() {
        if let mapVC = self.mapViewController, let routes = self.routes {
            let leg = routes.first?.legs.first
            guard let stepPoints = leg?.steps else { return }
            for step in stepPoints {
                let point = step.polyline.points
                let path = GMSPath.init(fromEncodedPath: point)!
//                self.pathArray.append(path)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeColor = UIColor(named: "mainRed")!
                polyline.strokeWidth = 5
                polyline.map = mapVC.mapView
            }
        }
    }
}

extension MapViewModel: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, locations: [CLLocationCoordinate2D]) {
        self.locations = locations
        self.updateMap(locations: locations)
    }
}
