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
    func drawSavedPolylines()
}

class MapViewModel: MapViewModelType {
    // MARK: - Properties
    private let locationManager = LocationManager()
    private var viewController: MapViewController!
    private var locations = [CLLocationCoordinate2D]()
    private var routes: [Route]?
    private var polyLinesArray = [GMSPolyline]()
    private var nextLocation: CLLocationCoordinate2D?
    private var isRecordingRoute = false
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
        self.recentCoordinates.removeAll()
        if self.locations.count >= 2 {
            self.recentCoordinates = self.locations.suffix(2)
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
    
    func drawSavedPolylines() {
        guard let routes = self.getSafely() else { return }
        for route in routes {
            self.viewController.createMarker(location: route.route[0], color: UIColor(named: "mainBlack"))
            self.viewController.createMarker(location: route.route[1], color: UIColor(named: "mainRed"))
            let point = route.polyLine.points
            self.createPolyline(from: point)
        }
    }

    // MARK: - Helpers
    func animateRoutes(steps: [Step]) {
        for (_, step) in steps.enumerated() {
            let point = step.polyline.points
            self.createPolyline(from: point)
        }
    }
    
    private func createPolyline(from point: String) {
        let path = GMSPath.init(fromEncodedPath: point)!
        let polyLine = GMSPolyline.init(path: path)
        if !polyLinesArray.contains(polyLine) {
            polyLine.strokeColor = UIColor(named: "mainRed")!.withAlphaComponent(0.8)
            polyLine.strokeWidth = 5
            polyLine.map = viewController.mapView
            polyLinesArray.append(polyLine)
        }
    }

    func handleRouteSaving(status: Bool) {
        if status {
            self.viewController.createMarker(location: self.recentCoordinates.suffix(2)[1], color: UIColor(named: "mainRed"))
            self.viewController.createAlertInput()
        }
    }
    
    private func getSafely() -> [UserRoute]? {
        guard let data = UserDefaults.standard.data(forKey: "userRoutes"),
              let routes = try? JSONDecoder().decode([UserRoute].self, from: data)
        else { return nil }
        return routes
    }
}

extension MapViewModel: LocationManagerDelegate {
    func showErrorMessage(message: String) {
    }
    
    func locationManager(_ manager: LocationManager, currentLocation: CLLocationCoordinate2D) {
        self.locations.append(currentLocation)
        self.nextLocation = locations.last
        self.viewController?.followRoute()
        if self.isRecordingRoute {
            self.fetchRoutes()
        }
    }
}
