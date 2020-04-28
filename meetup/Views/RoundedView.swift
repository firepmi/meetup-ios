//
//  RoundedView.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor        }
    }
}
