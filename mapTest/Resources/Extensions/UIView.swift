//
//  Extensions.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/11/21.
//

import UIKit

extension UIView {
    func center(inView view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func pinToEdges(ofView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        self.anchor(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat,
                bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat,
                left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat,
                right: NSLayoutXAxisAnchor?, paddingRight: CGFloat,
                width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top    = top {
            topAnchor.constraint(equalTo    : top,
                                 constant   : paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo : bottom,
                                    constant: -paddingBottom).isActive = true
        }
        if let right  = right {
            rightAnchor.constraint(equalTo  : right,
                                   constant : -paddingRight).isActive = true
        }
        if let left   = left {
            leftAnchor.constraint(equalTo   : left,
                                  constant  : paddingLeft).isActive = true
        }
        if width  != 0 {
            widthAnchor.constraint(equalToConstant  : width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant : height).isActive = true
        }
    }
}
