//
//  MapViewModel.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/12/21.
//

import UIKit
import GoogleMaps

protocol MapViewModelType: class {
    func getAllRoutes()
    func updatedLocation() -> CLLocationCoordinate2D?
    func changeRecordingStatus(shouldRecord: Bool)
}

class MapViewModel: MapViewModelType {
    // MARK: - Properties
    private let locationManager = LocationManager()
    private var viewController: MapViewController!
    private var locations = [CLLocationCoordinate2D]()
    private var routes: [Route]?
    var polyLinesArray = [Polyline]()
    private var nextLocation: CLLocationCoordinate2D?
    private var isRecordingRoute = false
    var currentLocation: CLLocationCoordinate2D!
    var recentCoordinates = [CLLocationCoordinate2D]()
    weak var delegate: MapViewControllerDelegate?
    var steps: [Step]?
    var leg: Leg!

    // MARK: - Init
    init(viewController: MapViewController) {
        self.viewController = viewController
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
            self.viewController.showAlertWith(message: "You must go to settings and authorize the location permissions in order to test the app.", title: "Authorization denied", type: .goToSettings)
        case .error:
            self.viewController.showAlertWith(message: "There was an error requesting the location authorization.", title: "An error has ocurred", type: .error)
        default:
            break
        }
    }

    // MARK: - Routes fetching
    func fetchRoutes() {
        if self.locations.count >= 2 {
            self.recentCoordinates.append(contentsOf: self.locations.suffix(2))
            ApiClient.shared.requestPlaces(locations: self.recentCoordinates.suffix(2), completion: { result in
                switch result {
                case .success(let routes):
                    self.routes = routes
                    self.delegate?.routeSuccess()
                case .failure(let error):
                    self.delegate?.routeFailure(type: error)
                }
            })
        }
    }

    // MARK: - MapViewModelType methods
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

    func updatedLocation() -> CLLocationCoordinate2D? {
        guard let location = self.nextLocation else {
            return nil
        }
        return location
    }

    func changeRecordingStatus(shouldRecord: Bool) {
        self.isRecordingRoute = shouldRecord
    }

    // MARK: - Helpers
    func animateRoutes(steps: [Step]) {
        for (_, step) in steps.enumerated() {
            let polyline = step.polyline
            self.polyLinesArray.append(polyline)
            self.createPolyline(from: polyline)
        }
    }
    
    private func createPolyline(from polyline: Polyline) {
        let point = polyline.points
        let path = GMSPath.init(fromEncodedPath: point)!
        let polyLine = GMSPolyline.init(path: path)
        polyLine.strokeColor = UIColor(named: "mainRed")!.withAlphaComponent(0.8)
        polyLine.strokeWidth = 5
        polyLine.map = viewController.mapView
        if !polyLinesArray.contains(polyline) {
            polyLinesArray.append(polyline)
        }
    }

    func handleRouteSaving(status: Bool) {
        if status,
           let lastCoord = self.recentCoordinates.last {
            self.viewController.createMarker(location: lastCoord, color: UIColor(named: "mainRed"))
            self.viewController.createAlertInput()
        }
    }
}

extension MapViewModel: LocationManagerDelegate {
    func showErrorMessage(message: String) {
    }
    
    func locationManager(_ manager: LocationManager, currentLocation: CLLocationCoordinate2D) {
        self.locations.append(currentLocation)
        self.nextLocation = locations.last
        self.currentLocation = locations.suffix(2).first
        self.viewController.followRoute()
        if self.isRecordingRoute {
            self.fetchRoutes()
        }
    }
}
