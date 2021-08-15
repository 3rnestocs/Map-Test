//
//  ListViewController.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit

class ListViewController: UIViewController {

    let tableView = UITableView()
    var routeDatasource: [UserRoute]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        self.setupUI()
    }
    
    private func setupUI() {
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "background")
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        self.view.addSubview(tableView)
        self.tableView.pinToSafeAreaEdges(ofView: view)
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.routeDatasource?.count ?? 0
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
        if let userRoute = routeDatasource?[indexPath.row] {
            cell.configureCell(kilometers: userRoute.distance, route: userRoute.name)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userRoute = routeDatasource?[indexPath.row] {
            let detailVC = DetailViewController()
            detailVC.route = userRoute
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
