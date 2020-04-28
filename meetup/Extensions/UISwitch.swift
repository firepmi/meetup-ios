//
//  UISwitch.swift
//  meetup
//
//  Created by An Phan  on 4/1/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
extension UISwitch {
    
    func set(width: CGFloat, height: CGFloat) {
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
