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
    func getAllRoutes()
    func updatePolylineAfterAnimation()
}

class MapViewModel: MapViewModelType {
    // MARK: - Properties
    weak var delegate: MapViewControllerDelegate?
    private var mapViewController: MapViewController!
    private let locationManager = LocationManager()
    private var locations: [CLLocationCoordinate2D]?
    private var routes: [Route]?
    private var steps: [Step]?
    var polyLine: GMSPolyline!
    var routeLocations = [CLLocationCoordinate2D]()

    // MARK: - Init
    init(viewController: MapViewController) {
        self.mapViewController = viewController
        self.setupLocation()
    }

    // MARK: - Location setup
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.getCurrentLocation()
    }

    private func focusUserLocation(userLocation: CLLocationCoordinate2D, mapVC: MapViewController) {
        mapVC.createMarkerOnUserLocation()
        let camera = GMSCameraPosition(target: userLocation, zoom: 4)
        let update = GMSCameraUpdate.setCamera(camera)
        mapVC.mapView.moveCamera(update)
    }

    private func updateMap(locations: [CLLocationCoordinate2D]) {
        if let mapVC = self.mapViewController {
            self.focusUserLocation(userLocation: locations[0], mapVC: mapVC)
        }
    }

    // MARK: - Routes fetching
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

    // MARK: - MapViewModelType methods
    func getLocations() -> [CLLocationCoordinate2D] {
        guard let locations = self.locations else { return
            [CLLocationCoordinate2D]()
        }
        return locations
    }

    func getAllRoutes() {
        if let routes = self.routes {
            let leg = routes.first?.legs.first
            guard let stepPoints = leg?.steps else { return }
            self.steps = stepPoints
        }
    }

    func updatePolylineAfterAnimation() {
        // This has a bug, it doesn't update the polyline's color when the animation finishes
        self.polyLine.spans = [GMSStyleSpan(color: UIColor(named: "mainRed")!)]
        self.polyLine.strokeColor = .red
    }

    // MARK: - Helpers
    func animateRoutes() {
        if let mapVC = self.mapViewController {
            self.cleanMapShapes(mapVC: mapVC)
            for (index, step) in steps!.enumerated() {
                let point = step.polyline.points
                let path = GMSPath.init(fromEncodedPath: point)!
                let pathLocation = path.coordinate(at: UInt(index))
                
                if pathLocation.latitude != -180.0, pathLocation.longitude != -180.0 {
                    self.routeLocations.append(path.coordinate(at: 1))
                }
                self.polyLine = GMSPolyline.init(path: path)
                self.polyLine.strokeColor = UIColor(named: "mainRed")!.withAlphaComponent(0.5)
                self.polyLine.strokeWidth = 5
                self.polyLine.map = mapVC.mapView
            }
        }
    }

    private func cleanMapShapes(mapVC: MapViewController) {
        self.routeLocations.removeAll()
        mapVC.mapView.clear()
        mapVC.createMarkerOnUserLocation()
    }
}

extension MapViewModel: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, locations: [CLLocationCoordinate2D]) {
        self.locations = locations
        self.updateMap(locations: locations)
    }
}
