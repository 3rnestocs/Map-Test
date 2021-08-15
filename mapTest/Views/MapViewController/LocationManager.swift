//
//  LocationManager.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/12/21.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ manager: LocationManager, currentLocation: CLLocationCoordinate2D)
}

class LocationManager: NSObject {

    enum AuthorizationStatus {
        case authorized
        case denied
        case error
        case undefined
    }

    // MARK: - Properties
    private var locationManager: CLLocationManager
    weak var delegate: LocationManagerDelegate?

    // MARK: - Initialize
    override init() {
        locationManager = CLLocationManager()
    }

    // MARK: - Public
    func getCurrentLocation() {
        locationManager.distanceFilter = 5
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    static func routeToSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }

    func checkStatus() -> AuthorizationStatus {
        var finalStatus: AuthorizationStatus = .undefined
        let status = locationManager.authorizationStatus
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                finalStatus = .authorized
            case .denied, .restricted:
                finalStatus = .denied
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            default:
                finalStatus = .error
            }
        return finalStatus
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        delegate?.locationManager(self, currentLocation: location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
