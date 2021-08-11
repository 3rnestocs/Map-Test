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
        for i in 0...(self.tabBar.items!.count - 1) {
            let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 16, width: CGFloat(separatorWidth), height: self.tabBar.frame.size.height - 16))
            separator.backgroundColor = UIColor(named: "mainWhite")

            self.tabBar.addSubview(separator)
        }
    }

    func createTabBarItem(viewController: UIViewController?, itemImage: UIImage) {
        let image = itemImage.imageWith(newSize: CGSize(width: 32, height: 32))
        viewController?.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: image)
    }
}
