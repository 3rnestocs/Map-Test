//
//  MapViewModel.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/12/21.
//

import UIKit
import GoogleMaps

protocol MapViewModelType: class {
    func getLocations() -> [CLLocationCoordinate2D]?
    func getAllRoutes()
    func updatePolylineAfterAnimation()
    func updatedLocation() -> CLLocationCoordinate2D?
}

class MapViewModel: MapViewModelType {
    // MARK: - Properties
    weak var delegate: MapViewControllerDelegate?
    private var mapViewController: MapViewController!
    private let locationManager = LocationManager()
    private var locations = [CLLocationCoordinate2D]()
    private var routes: [Route]?
    var steps: [Step]!
    var leg: Leg!
    private var polyLine: GMSPolyline!
    private var nextLocation: CLLocationCoordinate2D?
    private var recentCoordinates = [CLLocationCoordinate2D]()

    // MARK: - Init
    init(viewController: MapViewController) {
        self.mapViewController = viewController
        self.setupLocation()
    }

    // MARK: - Location setup
    private func setupLocation() {
        self.locationManager.delegate = self
        self.handleAuthorization()
        self.locations.removeAll()
    }

    private func handleAuthorization() {
        let status = locationManager.checkStatus()
        switch status {
        case .authorized:
            self.locationManager.getCurrentLocation()
        case .denied:
            self.mapViewController.showAlertWith(message: "You must go to settings and authorize the location permissions in order to test the app.", title: "Authorization denied", type: .goToSettings)
        case .error:
            self.mapViewController.showAlertWith(message: "There was an error requesting the location authorization.", title: "An error has ocurred", type: .error)
        default:
            break
        }
    }

    private func focusUserLocation(userLocation: CLLocationCoordinate2D, mapVC: MapViewController) {

        let camera = GMSCameraPosition(target: userLocation, zoom: 16)
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
        self.recentCoordinates.removeAll()
        for (index, _) in self.locations.enumerated() {
            if index > 2 {
                self.recentCoordinates = self.locations.suffix(2)
            }
        }
        ApiClient.shared.requestPlaces(locations: self.recentCoordinates, completion: { result in
            switch result {
            case .success(let routes):
                self.routes = routes
                self.delegate?.routeSuccess()
            case .failure(let error):
                self.delegate?.routeFailure(type: error)
            }
        })
    }

    // MARK: - MapViewModelType methods
    func getLocations() -> [CLLocationCoordinate2D]? {
        if !self.locations.isEmpty {
            return locations
        } else {
            return nil
        }
    }

    func getAllRoutes() {
        if let routes = self.routes,
           !routes.isEmpty {
            guard let leg = routes.first?.legs.first else {
                return
            }
            self.leg = leg
            let stepPoints = leg.steps
            self.steps = stepPoints
            self.animateRoutes(steps: stepPoints)
        }
    }

    func updatePolylineAfterAnimation() {
        // This has a bug, it doesn't update the polyline's color when the animation finishes
        self.polyLine.spans = [GMSStyleSpan(color: UIColor(named: "mainRed")!)]
        self.polyLine.strokeColor = .red
    }

    func updatedLocation() -> CLLocationCoordinate2D? {
        guard let location = self.nextLocation else {
            return nil
        }
        return location
    }

    // MARK: - Helpers
    func animateRoutes(steps: [Step]) {
        if let mapVC = self.mapViewController {
            for (_, step) in steps.enumerated() {
                let point = step.polyline.points
                let path = GMSPath.init(fromEncodedPath: point)!
                self.polyLine = GMSPolyline.init(path: path)
                self.polyLine.strokeColor = UIColor(named: "mainRed")!.withAlphaComponent(0.8)
                self.polyLine.strokeWidth = 5
                self.polyLine.map = mapVC.mapView
            }
        }
    }
}

extension MapViewModel: LocationManagerDelegate {
    func showErrorMessage(message: String) {
    }
    
    func locationManager(_ manager: LocationManager, currentLocation: CLLocationCoordinate2D) {
        if !self.locations.contains(currentLocation) {
            self.locations.append(currentLocation)
            self.mapViewController?.followRoute()
        } else {
            self.mapViewController.shouldStopTracking = true
        }
        if currentLocation != locations.first {
            self.nextLocation = currentLocation
        }
    }
}

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
