//
//  Extension.swift
//  Tour Guide Demo
//
//  Created by developer on 19/02/19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func addShadow(radius: CGFloat){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1
    }
    
    func addCornerRadius(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func startProgressHub(){
        let bgview = UIView()
        bgview.frame = self.frame
        bgview.tag = 140
        bgview.backgroundColor = UIColor.black
        bgview.alpha = 0.5
        let view = UIActivityIndicatorView()
        view.tag = 40
        view.startAnimating()
        view.center = bgview.center
        bgview.addSubview(view)
        self.addSubview(bgview)
    }
    
    func stopProgresshub(){
        let view = self.viewWithTag(40) as? UIActivityIndicatorView
        let bgview = self.viewWithTag(140)
        view?.stopAnimating()
        view?.removeFromSuperview()
        bgview?.removeFromSuperview()
    }
}

extension UIViewController{
    
    func showalert(msg: String, completion:(()->())? = nil){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion?()
        }))
       self.present(alert, animated: true, completion: nil)
    }
    
    func dateConverter(string: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        let date = dateFormatter.date(from: string)
        return dateFormatter.string(from: date ?? Date())
    }
    
    func getTimeFromTimeInterval(interval:Int64) -> String {
        var time = Double(interval)
        time = time/1000.0
        let date = Date.init(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
    func getStringFromInterval(interval:Int64) -> String {
        var time = Double(interval)
        time = time/1000.0
        let date = Date.init(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter.string(from: date)
    }
    func getTime() -> NSNumber {
        var timeStamp = Date().timeIntervalSince1970
        timeStamp = timeStamp*1000
        return   NSNumber(value: Int64(timeStamp))
    }
}


extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}


class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
