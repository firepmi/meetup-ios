//
//  RoundedTextField.swift
//  Gomble
//
//  Created by mobileworld on 8/13/20.
//  Copyright © 2020 Haley Huynh. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedTextField: UITextField {
    
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
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}

