//
//  MapViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/10/21.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        self.setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = UIColor(named: "background")
    }
}

