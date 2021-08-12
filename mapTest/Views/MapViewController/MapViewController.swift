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

class MapViewController: UIViewController {
    
    private let startButton = UIButton(type: .system)
    public var mapView: GMSMapView!
    private var locationManager: LocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationManager?.setupLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.layer.cornerRadius = startButton.frame.height / 2
    }
    
    private func setup() {
        self.setupMap()
        self.setupLocationManager()
        self.setupUI()
    }

    private func setupLocationManager() {
        let manager = CLLocationManager()
        self.locationManager = LocationManager(locationManager: manager, mapVC: self)
        self.locationManager?.manager.delegate = locationManager
        self.setupMarkers()
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
        let source = locationManager!.sourceLocation
        let destination = locationManager!.destinationLocation
        let sourceLocation = "\(source.latitude),\(source.longitude)"
        let destinationLocation = "\(destination.latitude),\(destination.longitude)"
                
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=AIzaSyAFCmJTHfdwUprZHZ7pB48Lj6HlYJwKTXw"
        if let url = URL(string: urlString) {
            fetchRequest(url: url)
            self.followRoute()
        }
    }

    private func followRoute() {
        let camera = GMSCameraPosition(target: locationManager!.destinationLocation, zoom: 10)
        let update = GMSCameraUpdate.setCamera(camera)
        self.mapView.moveCamera(update)
    }

    private func setupMarkers() {
        let sourceMarker = GMSMarker()
        sourceMarker.position = locationManager!.sourceLocation
        sourceMarker.title = "Caracas"
        sourceMarker.snippet = "Capital de Venezuela"
        sourceMarker.map = self.mapView
        
        let destinationMarker = GMSMarker()
        destinationMarker.position = locationManager!.destinationLocation
        destinationMarker.title = "Barquisimeto"
        destinationMarker.snippet = "Capital musical venezolana"
        destinationMarker.map = self.mapView
    }

    private func fetchRequest(url: URL) {
        AF.request(url).responseJSON { (reseponse) in
            guard let data = reseponse.data else {
                return
            }

            do {
                let jsonData = try JSON(data: data)
                let routes = jsonData["routes"].arrayValue
                print(jsonData)

                for route in routes {
                    let overview_polyline = route["overview_polyline"].dictionary
                    let points = overview_polyline?["points"]?.string
                    let path = GMSPath.init(fromEncodedPath: points ?? "")
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = .systemBlue
                    polyline.strokeWidth = 5
                    polyline.map = self.mapView
                }
            }
             catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
