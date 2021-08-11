//
//  MapViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/10/21.
//

import UIKit

class MapViewController: UIViewController {

    private let startButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.layer.cornerRadius = startButton.frame.height / 2
    }

    private func setup() {
        self.setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = UIColor(named: "background")
        self.setupStartRouteButton()
    }

    private func setupStartRouteButton() {
        self.view.addSubview(startButton)
        startButton.setAttributedTitle(NSAttributedString(string: "START", attributes: [
                                                        .font: UIFont.systemFont(ofSize: 16, weight: .heavy),
                                                        .foregroundColor: UIColor(named: "mainRed")!]), for: .normal)
        startButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 48, left: view.leftAnchor, paddingLeft: 48, right: view.rightAnchor, paddingRight: 48, width: 0, height: 48)
        startButton.backgroundColor = UIColor(named: "mainBlack")
        startButton.addTarget(self, action: #selector(self.didTapStartButton(_:)), for: .touchUpInside)
    }

    @objc private func didTapStartButton(_ sender: UIButton) {
    }
}

