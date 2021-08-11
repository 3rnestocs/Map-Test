//
//  UITabBar.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit

extension UITabBarController {
    func createSeparatorsBetweenItems() {
        let itemWidth = floor(self.tabBar.frame.size.width / CGFloat(self.tabBar.items!.count))
        let separatorWidth: CGFloat = 0.7
        let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(1) - CGFloat(separatorWidth / 2), y: 16, width: CGFloat(separatorWidth), height: self.tabBar.frame.size.height - 24))
        separator.backgroundColor = UIColor(named: "mainWhite")

        self.tabBar.addSubview(separator)
    }

    func createTabBarItem(viewController: UIViewController?, itemImage: UIImage, title: String) {
        let isSmallDevice = UIScreen.main.bounds.height <= 700
        let itemTitle: String = isSmallDevice ? "" : title
        let image = itemImage.imageWith(newSize: CGSize(width: 25, height: 25))
        viewController?.tabBarItem = UITabBarItem(title: itemTitle, image: image, selectedImage: image)
    }
}
