//
//  UIImage.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit

extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
            
        return image.withRenderingMode(renderingMode)
    }

    static func createMarkerIcon(tintColor: UIColor, icon: String, size: CGFloat) -> UIImage {
        guard let marker = UIImage(named: icon)?.withTintColor(tintColor)
                .imageWith(newSize: CGSize(width: size, height: size)) else {
            return UIImage()
        }
        return marker
    }
}
