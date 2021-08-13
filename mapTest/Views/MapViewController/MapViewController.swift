//
//  MapViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/10/21.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

protocol MapViewControllerDelegate: class {
    func routeDrawingSuccess()
    func routeDrawingFailure()
}

class MapViewController: UIViewController {
    
    private let startButton = UIButton(type: .system)
    public var mapView: GMSMapView!
    public var viewModel: MapViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.layer.cornerRadius = startButton.frame.height / 2
    }
    
    private func setup() {
        self.setupVM()
        self.setupMap()
        self.setupUI()
    }

    private func setupVM() {
        self.viewModel = MapViewModel(viewController: self)
        self.viewModel.delegate = self
    }
    
    private func setupUI() {
        self.setupButton()
    }
    
    private func setupMap() {
        self.mapView = GMSMapView(frame: self.view.bounds)
        self.view.addSubview(mapView)
    }

    private func setupButton() {
        self.view.addSubview(startButton)
        startButton.setAttributedTitle(NSAttributedString(string: "START", attributes: [
                                        .font: UIFont.systemFont(ofSize: 16, weight: .heavy),
                                        .foregroundColor: UIColor(named: "mainRed")!]),
                                       for: .normal)
        startButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 48, left: view.leftAnchor, paddingLeft: 48, right: view.rightAnchor, paddingRight: 48, width: 0, height: 48)
        startButton.backgroundColor = UIColor(named: "mainBlack")
        startButton.addTarget(self, action: #selector(self.didTapStartButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapStartButton(_ sender: UIButton) {
        self.viewModel.fetchRoutes()
    }

    private func followRoute() {
        let camera = GMSCameraPosition(target: viewModel.getLocations()[1], zoom: 10)
        let update = GMSCameraUpdate.setCamera(camera)
        self.mapView.moveCamera(update)
    }

    func focusUserLocation(userLocation: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition(target: userLocation, zoom: 10)
        let update = GMSCameraUpdate.setCamera(camera)
        self.mapView.moveCamera(update)
    }

    func setupMarkers(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let sourceMarker = GMSMarker()
        sourceMarker.position = source
        sourceMarker.map = self.mapView
        
        let destinationMarker = GMSMarker()
        destinationMarker.position = destination
        destinationMarker.map = self.mapView
    }
}

extension MapViewController: MapViewControllerDelegate {
    func routeDrawingSuccess() {
        self.viewModel.drawRouteOnMap()
    }
    
    func routeDrawingFailure() {
        print("Nestor failed")
    }
}
