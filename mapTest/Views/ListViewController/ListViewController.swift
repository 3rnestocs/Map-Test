//
//  ListViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit

class ListViewController: UIViewController {

    let tableView = UITableView()
    public var viewModel: ListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        self.setupUI()
    }
    
    private func setupUI() {
        self.setupTableView()
        self.view.backgroundColor = UIColor(named: "mainBlack")
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "mainBlack")
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        self.view.addSubview(tableView)
        self.tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 24, bottom: view.bottomAnchor, paddingBottom: 16, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.getRoutes().count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        let userRoute = self.viewModel.getRoutes()[indexPath.row]
        cell.configureCell(kilometers: userRoute.distance, route: userRoute.name)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userRoute = self.viewModel.getRoutes()[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.viewModel = DetailViewModel(viewController: detailVC)
        detailVC.viewModel.detailedRoute = userRoute
        detailVC.delegate = self
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ListViewController: DetailViewControllerDelegate {
    func routeDeleted() {
        self.tableView.reloadData()
    }
}
