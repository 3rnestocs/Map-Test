//
//  MapViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/10/21.
//

import UIKit
import GoogleMaps
import Alamofire

protocol MapViewControllerDelegate: class {
    func routeSuccess()
    func routeFailure(type: ErrorCases)
}

protocol MapViewAlertTextDelegate: class {
    func didSubmitRouteName(routeData: UserRoute)
}

class MapViewController: UIViewController {
    
    // MARK: - Properties
    private let startButton = UIButton(type: .system)
    public var mapView: GMSMapView!
    public var viewModel: MapViewModel!
    private var shapeLayer: CAShapeLayer!
    weak var delegate: MapViewAlertTextDelegate?
    var shouldStopTracking = false
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.layer.cornerRadius = startButton.frame.height / 2
    }
    
    // MARK: - Setup
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
        self.mapView.delegate = self
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

    private func createAlertInput() {
        let alert = UIAlertController(title: "Record your route", message: "Type in your route name to check it out later.", preferredStyle: .alert)
        alert.addTextField { _ in }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0],
               let text = textField.text {
                let step = self.viewModel.steps.last
                let routeData = UserRoute(route: [CLLocationCoordinate2D](), name: text, distance: step?.distance.value ?? 0, duration: step?.duration.text ?? "")
                self.delegate?.didSubmitRouteName(routeData: routeData)
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func followRoute() {
        if let currentLocation = self.viewModel.updatedLocation(),
           shouldStopTracking == false {
            let camera = GMSCameraPosition(target: currentLocation, zoom: 12)
            let update = GMSCameraUpdate.setCamera(camera)
            self.mapView.moveCamera(update)
//            self.mapView.clear()
            self.createMarker(location: currentLocation, color: UIColor(named: "mainRed"))
        }
    }

    private func createMarker(location: CLLocationCoordinate2D, color: UIColor?) {
        let marker = GMSMarker()
        marker.position = location
        marker.icon = markerIcon(tintColor: color!)
        marker.map = self.mapView
    }

    private func markerIcon(tintColor: UIColor) -> UIImage {
        guard let marker = UIImage(named: "pin")?.withTintColor(tintColor)
                .imageWith(newSize: CGSize(width: 32, height: 32)) else {
            return UIImage()
        }
        return marker
    }
    
    enum AlertType {
        case goToSettings
        case error
    }

    func showAlertWith(message: String, title: String, type: AlertType) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true)
        }))
        
        if type == .goToSettings {
            alert.addAction(UIAlertAction(title: "Go to settings", style: .default, handler: { _ in
                LocationManager.routeToSettings()
            }))
        }

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Actions
    @objc private func didTapStartButton(_ sender: UIButton) {
        self.viewModel.fetchRoutes()
    }
}

extension MapViewController: MapViewControllerDelegate, GMSMapViewDelegate {
    func routeSuccess() {
        self.viewModel.getAllRoutes()
    }

    func routeFailure(type: ErrorCases) {
        switch type {
        case .badJSON:
            self.showAlertWith(message: "An error has ocurred when the data was retrieved", title: "Request failed", type: .error)
        case .buildUrl:
            self.showAlertWith(message: "You must give the location authorization in order to test the app.", title: "Missing authorization", type: .error)
        }
    }
}
