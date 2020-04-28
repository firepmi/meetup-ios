//
//  MyNavigationController.swift
//  SwiftSideMenu
//

import UIKit

class MyNavigationController: ENSideMenuNavigationController {
    
    //MARK: - ViewLifeCycles 
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MenuViewController(), menuPosition:.right)
        //sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = (UIScreen.main.bounds.width * 7) / 10
        //sideMenu?.bouncingEnabled = false
        //sideMenu?.allowPanGesture = false
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - ENSideMenuDelegate -
extension MyNavigationController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
}
