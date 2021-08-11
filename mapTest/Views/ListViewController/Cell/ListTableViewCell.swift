//
//  ListTableViewCell.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    static let identifier = String(describing: self)
    private let kmLabel = UILabel()
    private let routeLabel = UILabel()
    private let separatorView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = UIColor(named: "background")
        self.setupLabels()
    }

    private func setupLabels() {
        self.addSubview(kmLabel)
        self.addSubview(routeLabel)

        self.kmLabel.anchor(top: topAnchor, paddingTop: 0, bottom: routeLabel.topAnchor, paddingBottom: 12, left: leftAnchor, paddingLeft: 24, right: nil, paddingRight: 0, width: 0, height: 0)
        self.kmLabel.font = UIFont.systemFont(ofSize: 16)
        self.routeLabel.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: kmLabel.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        self.routeLabel.font = UIFont.systemFont(ofSize: 16)
        self.setupSeparatorView()
    }

    func setupSeparatorView() {
        self.addSubview(separatorView)
        self.separatorView.backgroundColor = UIColor(named: "mainBlack")
        separatorView.anchor(top: routeLabel.bottomAnchor, paddingTop: 16, bottom: bottomAnchor, paddingBottom: 16, left: leftAnchor, paddingLeft: 20, right: rightAnchor, paddingRight: 20, width: 0, height: 1)
    }

    func removeSeparatorView(shouldShow: Bool) {
        self.separatorView.isHidden = shouldShow
        routeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16).isActive = shouldShow
        layoutIfNeeded()
    }

    func configureCell(kilometers: Int, route: String) {
        self.kmLabel.text = "\(kilometers) kilometers traveled"
        self.routeLabel.text = route
    }
}
