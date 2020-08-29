//
//  UIViewController.swift
//  meetup
//
//  Created by An Phan on 3/24/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String?,
                   message: String?,
                   style: UIAlertController.Style = .alert,
                   actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach({ alertController.addAction($0) })
        present(alertController, animated: true, completion: nil)
    }
    
    func gradientOfNavigationBar() {
        var colors = [UIColor]()
        colors.append(UIColor(hexString: "ffffff")) //FF7761
        colors.append(UIColor(hexString: "ffffff")) //E51F41
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
}
