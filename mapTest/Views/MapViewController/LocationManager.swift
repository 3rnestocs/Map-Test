//
//  LocationManager.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/12/21.
//

import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ manager: LocationManager, locations: [CLLocationCoordinate2D])
}

class LocationManager: NSObject {

    // MARK: - Properties
    private var locationManager: CLLocationManager
    private let destinationLocation = CLLocationCoordinate2D(latitude: 10.063611, longitude: -69.334724)
    weak var delegate: LocationManagerDelegate?

    // MARK: - Initialize
    override init() {
        locationManager = CLLocationManager()
    }

    // MARK: - Public
    func getCurrentLocation() {
        locationManager.distanceFilter = 150
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }

        delegate?.locationManager(self, locations: [userLocation.coordinate, destinationLocation])
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
