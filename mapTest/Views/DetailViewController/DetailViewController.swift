//
//  DetailViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit
import GoogleMaps

protocol DetailViewControllerDelegate: class {
    func routeDeleted()
}

class DetailViewController: UIViewController {
    
    private var routeView = UIView()
    private var routeNameLabel = UILabel()
    private var distanceLabel = UILabel()
    private var durationLabel = UILabel()
    private var shareButton = UIButton()
    private var deleteButton = UIButton()
    private var mapView: GMSMapView!
    weak var delegate: DetailViewControllerDelegate?
    var viewModel: DetailViewModel!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        shareButton.layer.cornerRadius = shareButton.frame.height / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Route details"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "mainRed")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateMapLocation()
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor(named: "mainBlack")
        self.setupMap()
        self.setupButtons()
        self.setupLabels()
    }

    private func setupMap() {
        self.mapView = GMSMapView()
        self.view.addSubview(mapView)
        self.mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 8, right: view.rightAnchor, paddingRight: 8, width: 0, height: 208)
    }

    private func updateMapLocation() {
        guard let route = self.viewModel.detailedRoute?.route[0] else { return }
        let camera = GMSCameraPosition(latitude: route.latitude, longitude: route.longitude, zoom: 15)
        let update = GMSCameraUpdate.setCamera(camera)
        self.mapView.moveCamera(update)
        self.showRoute()
    }

    private func showRoute() {
        guard let route = self.viewModel.detailedRoute else { return }
        let point = route.polyLine.points
        let path = GMSPath.init(fromEncodedPath: point)!
        let polyLine = GMSPolyline.init(path: path)
        
        polyLine.strokeColor = UIColor(named: "mainRed")!.withAlphaComponent(0.8)
        polyLine.strokeWidth = 5
        polyLine.map = self.mapView
        
        let coord = route.route
        createMarker(location: coord[0], color: UIColor(named: "mainBlack"), map: self.mapView)
        createMarker(location: coord[1], color: UIColor(named: "mainRed"), map: self.mapView)
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
                                        .foregroundColor: UIColor(named: "mainBlack")!]),
                                       for: .normal)
        deleteButton.anchor(top: nil, paddingTop: 0, bottom: shareButton.bottomAnchor, paddingBottom: 0, left: nil, paddingLeft: 0, right: view.rightAnchor, paddingRight: 20, width: 0, height: 48)
        shareButton.anchor(top: nil, paddingTop: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20, left: view.leftAnchor, paddingLeft: 20, right: deleteButton.leftAnchor, paddingRight: 16, width: 104, height: 48)
        deleteButton.backgroundColor = UIColor(named: "mainRed")
        shareButton.backgroundColor = UIColor(named: "background")
        deleteButton.addTarget(self, action: #selector(deleteButtonTouched(_:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTouched(_:)), for: .touchUpInside)
    }
    
    private func setupLabels() {
        guard let route = self.viewModel.detailedRoute else { return }
        self.view.addSubview(routeNameLabel)
        self.view.addSubview(distanceLabel)
        self.view.addSubview(durationLabel)
        
        self.routeNameLabel.anchor(top: self.mapView.bottomAnchor, paddingTop: 16,
                                   bottom: nil, paddingBottom: 0,
                                   left: view.leftAnchor, paddingLeft: 48,
                                   right: view.rightAnchor, paddingRight: 48,
                                   width: 0, height: 0)
        self.routeNameLabel.attributedText = NSAttributedString(string: route.name.capitalized, attributes: [
                .foregroundColor: UIColor(named: "background")!,
                .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ])
        self.routeNameLabel.textAlignment = .center
        
        self.distanceLabel.anchor(top: self.routeNameLabel.bottomAnchor, paddingTop: 24,
                                   bottom: nil, paddingBottom: 0,
                                   left: view.leftAnchor, paddingLeft: 24,
                                   right: view.rightAnchor, paddingRight: 24,
                                   width: 0, height: 0)
        self.distanceLabel.attributedText = NSAttributedString(string: "\(route.distance) kilometers traveled", attributes: [
                .foregroundColor: UIColor(named: "mainRed")!,
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ])
        
        self.durationLabel.anchor(top: self.distanceLabel.bottomAnchor, paddingTop: 16,
                                   bottom: nil, paddingBottom: 0,
                                   left: view.leftAnchor, paddingLeft: 24,
                                   right: view.rightAnchor, paddingRight: 24,
                                   width: 0, height: 0)
        self.durationLabel.attributedText = NSAttributedString(string: route.duration, attributes: [
                .foregroundColor: UIColor(named: "mainRed")!,
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ])
    }

    // MARK: - Actions
    @objc private func deleteButtonTouched(_ sender: UIButton) {
        self.viewModel.deleteRoute()
        self.navigationController?.popViewController(animated: true)
        self.delegate?.routeDeleted()
    }
    
    @objc private func shareButtonTouched(_ sender: UIButton) {
        
    }
}
