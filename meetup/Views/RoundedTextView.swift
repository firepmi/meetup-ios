//
//  RoundedTextView.swift
//  Gomble
//
//  Created by mobileworld on 8/19/20.
//  Copyright © 2020 Haley Huynh. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedTextView: UITextView {
    
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
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var leftPadding: CGFloat = 10 {
        didSet {
            textContainerInset.left = leftPadding
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 10 {
        didSet {
            textContainerInset.right = rightPadding
        }
    }
}

