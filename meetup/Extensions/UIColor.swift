//
//  UIColor.swift
//  meetup
//
//  Created by An Phan on 3/21/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    /// useful macros
    class func rgbColor(red r: Float, green g: Float, blue b: Float) -> UIColor {
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1.0)
    }
    
    class func rgbaColor(red r: Float, green g: Float, blue b: Float, alpha a: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: a)
    }
    
    /**
     * Separate line view, placeholder text color of the application
     * @return UIColor color to use
     */
    
    class func mainColor() -> UIColor {
        return UIColor(hexString: "ffe1e1")
    }
    
    class func borderColor() -> UIColor {
        return UIColor(hexString: "ffa6a6")
    }
    class func grayColor() -> UIColor {
        return UIColor(hexString: "E6E6E6")
    }
    class func redColor() -> UIColor {
        return UIColor(hexString: "FD6666")
    }

}
