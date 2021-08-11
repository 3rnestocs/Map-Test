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
        self.setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }

    private func setup() {
        self.setupTabBar()
    }

    private func setupNavigationBar() {
        let img = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    private func setupTabBar() {
        self.tabBar.barTintColor = UIColor(named: "mainBlack")
        self.tabBar.tintColor = UIColor(named: "mainRed")
        self.tabBar.unselectedItemTintColor = UIColor(named: "mainWhite")
        self.tabBar.isTranslucent = false
        self.setupTabBarViewControllers()
        self.createSeparatorsBetweenItems()
    }

    private func setupTabBarViewControllers() {
        if mapViewController == nil, listViewController == nil {
            self.mapViewController = MapViewController()
            self.listViewController = ListViewController()
        }

        createTabBarItem(viewController: mapViewController, itemImage: UIImage(named: "map")!, title: "Map")
        createTabBarItem(viewController: listViewController, itemImage: UIImage(named: "list")!, title: "List")

        guard let tabOne = self.mapViewController,
              let tabTwo = self.listViewController
        else { return }

        self.viewControllers = [tabOne, tabTwo]
    }
}
