//
//  HomeViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit

class HomeViewController: UITabBarController {

    private var mapViewController: MapViewController?
    private var listViewController: ListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTabChilds()
        self.setupBars()
    }

    private func setupBars() {
        let img = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        self.tabBar.barTintColor = UIColor(named: "mainBlack")
        self.tabBar.tintColor = UIColor(named: "mainRed")
        self.tabBar.unselectedItemTintColor = UIColor(named: "mainWhite")
        self.tabBar.isTranslucent = false
        self.createSeparatorsBetweenItems()
    }

    private func setupTabChilds() {
        if mapViewController == nil, listViewController == nil {
            self.mapViewController = MapViewController()
            self.listViewController = ListViewController()
        }

        self.createTabBarItem(viewController: mapViewController, itemImage: UIImage(named: "map")!)
        self.createTabBarItem(viewController: listViewController, itemImage: UIImage(named: "list")!)

        guard let tabOne = self.mapViewController,
              let tabTwo = self.listViewController
        else { return }

        self.viewControllers = [tabOne, tabTwo]
    }
}
