//
//  LocationManager.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/12/21.
//

import UIKit
import GoogleMaps

class LocationManager: NSObject {
    public var manager: CLLocationManager!
    let sourceLocation = CLLocationCoordinate2D(latitude: 10.4696404, longitude: -66.8037185)
    let destinationLocation = CLLocationCoordinate2D(latitude: 10.063611, longitude: -69.334724)
    private var mapViewController: MapViewController!
    
    init(locationManager: CLLocationManager,
         mapVC: MapViewController) {
        self.manager = locationManager
        self.mapViewController = mapVC
    }

    func setupLocation() {
        if CLLocationManager.locationServicesEnabled() {
            self.manager.requestLocation()
            self.mapViewController.mapView.isMyLocationEnabled = true
            self.mapViewController.mapView.settings.myLocationButton = true
        } else {
            self.manager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        self.manager.requestLocation()
        self.mapViewController.mapView.isMyLocationEnabled = true
        self.mapViewController.mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        self.mapViewController.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
