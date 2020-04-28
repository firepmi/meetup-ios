//
//  UINavigationBar.swift
//  meetup
//
//  Created by An Phan on 3/21/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setGradientBackground(colors: [UIColor]) {
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}
