//
//  UIView.swift
//  meetup
//
//  Created by An Phan on 3/24/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit

extension UIView {
    func roundRadius() {
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func bordered(withColor color: UIColor, width: CGFloat, radius: CGFloat? = nil) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        if let radius = radius {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
        }
    }
}
