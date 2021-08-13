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
    func routeDrawingSuccess()
    func routeDrawingFailure()
}

class MapViewController: UIViewController {
    
    // MARK: - Properties
    private let startButton = UIButton(type: .system)
    public var mapView: GMSMapView!
    public var viewModel: MapViewModel!
    private var shapeLayer: CAShapeLayer!

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

    func setupShape() {
        self.shapeLayer = self.layer()
        self.animatePath(shapeLayer)
        self.mapView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Helpers
    private func followRoute() {
        let camera = GMSCameraPosition(target: viewModel.getLocations()[1], zoom: 4)
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

    func handleShapeAnimationEnd() {
        self.shapeLayer.removeFromSuperlayer()
        self.shapeLayer.removeAllAnimations()
        self.viewModel.updatePolylineAfterAnimation()
        self.mapView.animate(toLocation: self.viewModel.getLocations()[1])
    }

    // MARK: - CAShapeLayer
    func layer() -> CAShapeLayer {
        let breizerPath = UIBezierPath()
        let firstCoordinate = self.viewModel.routeLocations[0]
        breizerPath.move(to: self.mapView.projection.point(for: firstCoordinate))
        for i in self.viewModel.routeLocations {
            let coordinate: CLLocationCoordinate2D = i
            breizerPath.addLine(to: self.mapView.projection.point(for: coordinate))
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = breizerPath.cgPath
        shapeLayer.strokeColor = UIColor(named: "mainRed")!.cgColor
        shapeLayer.lineWidth = 5.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }

    func animatePath(_ layer: CAShapeLayer) {
        CATransaction.begin()
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 5
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        pathAnimation.fromValue = Int(0.0)
        pathAnimation.toValue = Int(1.0)
        
        CATransaction.setCompletionBlock {
            self.handleShapeAnimationEnd()
        }

        layer.add(pathAnimation, forKey: "strokeEnd")
        CATransaction.commit()
    }

    // MARK: - Actions
    @objc private func didTapStartButton(_ sender: UIButton) {
        self.viewModel.fetchRoutes()
    }
}

extension MapViewController: MapViewControllerDelegate, GMSMapViewDelegate {
    func routeDrawingSuccess() {
        UIView.animate(withDuration: 0.05) {
            self.viewModel.getAllRoutes()
        } completion: { _ in
            self.viewModel.animateRoutes()
            self.setupShape()
        }
    }

    func routeDrawingFailure() {
        print("Nestor failed")
    }
}
