//
//  UINavigationController.swift
//  meetup
//
//  Created by An Phan  on 4/1/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
}
