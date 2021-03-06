//
//  HomeViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit

class HomeViewController: UITabBarController {
    
    // MARK: - Properties
    private var mapViewController: MapViewController?
    private var listViewController: ListViewController?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    // MARK: - Setup
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let vc = self.viewControllers?.first {
            if vc.tabBarItem == item {
                self.title = ""
            } else {
                self.title = "Saved routes"
            }
        }
    }

    private func setup() {
        self.setupTabBar()
    }

    private func setupNavigationBar() {
        let img = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor(named: "mainBlack")
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "mainRed")!,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
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
            self.mapViewController?.delegate = self
        }

        createTabBarItem(viewController: mapViewController, itemImage: UIImage(named: "map")!, title: "Map")
        createTabBarItem(viewController: listViewController, itemImage: UIImage(named: "list")!, title: "List")

        guard let tabOne = self.mapViewController,
              let tabTwo = self.listViewController
        else { return }
        
        self.mapViewController?.viewModel = MapViewModel(viewController: tabOne)
        self.listViewController?.viewModel = ListViewModel(viewController: tabTwo)

        self.viewControllers = [tabOne, tabTwo]
    }
}

// MARK: - MapViewAlertTextDelegate
extension HomeViewController: MapViewAlertTextDelegate {
    func didSubmitRouteName(routeData: UserRoute) {
        self.listViewController?.viewModel.saveRoutes(route: routeData)
        self.listViewController?.tableView.reloadData()
    }
}
