//
//  DetailViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit
import GoogleMaps

class DetailViewController: UIViewController {
    
    private var routeView = UIView()
    private var routeName = UILabel()
    private var distance = UILabel()
    private var duration = UILabel()
    private var shareButton = UIButton()
    private var deleteButton = UIButton()
    private var mapView: GMSMapView!
    var route: UserRoute!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.backgroundColor = .orange
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        shareButton.layer.cornerRadius = shareButton.frame.height / 2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateMapLocation()
    }
    
    private func setupUI() {
        self.setupMap()
        self.setupButtons()
//        self.routeName.text = route.name
//        self.distance.text = "\(route.distance) kilometers traveled"
//        self.duration.text = route.duration
    }

    private func setupMap() {
        self.mapView = GMSMapView()
        self.view.addSubview(mapView)
        self.mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 148)
        self.mapView.delegate = self
    }

    private func updateMapLocation() {
        let camera = GMSCameraPosition(latitude: route.route[0].latitude, longitude: route.route[0].longitude, zoom: 15)
        let update = GMSCameraUpdate.setCamera(camera)
        self.mapView.moveCamera(update)
        self.showRoute()
    }

    private func showRoute() {
        let point = self.route.polyLine.points
        let path = GMSPath.init(fromEncodedPath: point)!
        let polyLine = GMSPolyline.init(path: path)
        polyLine.strokeColor = UIColor(named: "mainRed")!.withAlphaComponent(0.8)
        polyLine.strokeWidth = 5
        polyLine.map = self.mapView
        createMarker(location: self.route.route[0], color: UIColor(named: "mainBlack"), map: self.mapView)
        createMarker(location: self.route.route[1], color: UIColor(named: "mainRed"), map: self.mapView)
    }

    func createMarker(location: CLLocationCoordinate2D, color: UIColor?, map: GMSMapView) {
        let marker = GMSMarker()
        marker.position = location
        marker.icon = UIImage.createMarkerIcon(tintColor: color!, icon: "pin", size: 32)
        marker.map = map
    }

    private func setupButtons() {
        self.view.addSubview(deleteButton)
        self.view.addSubview(shareButton)
        deleteButton.setAttributedTitle(NSAttributedString(string: "Delete route", attributes: [
                                        .font: UIFont.systemFont(ofSize: 16, weight: .heavy),
                                        .foregroundColor: UIColor(named: "mainBlack")!]),
                                        for: .normal)
        shareButton.setAttributedTitle(NSAttributedString(string: "Share", attributes: [
                                        .font: UIFont.systemFont(ofSize: 16, weight: .heavy),
                                        .foregroundColor: UIColor(named: "mainWhite")!]),
                                       for: .normal)
        deleteButton.anchor(top: nil, paddingTop: 0, bottom: shareButton.bottomAnchor, paddingBottom: 0, left: nil, paddingLeft: 0, right: view.rightAnchor, paddingRight: 20, width: 0, height: 48)
        shareButton.anchor(top: nil, paddingTop: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20, left: view.leftAnchor, paddingLeft: 20, right: deleteButton.leftAnchor, paddingRight: 16, width: 84, height: 48)
        deleteButton.backgroundColor = UIColor(named: "mainRed")
        shareButton.backgroundColor = UIColor(named: "mainBlack")
        deleteButton.addTarget(self, action: #selector(deleteButtonTouched(_:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTouched(_:)), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func deleteButtonTouched(_ sender: UIButton) {

    }
    
    @objc private func shareButtonTouched(_ sender: UIButton) {
        
    }
}

extension DetailViewController: GMSMapViewDelegate {
    
}
