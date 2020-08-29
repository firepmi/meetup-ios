//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Alamofire
import SwiftyJSON

class MenuViewController: UITableViewController {
    
    //MARK: - Variables
    let menu: [String] = ["Home","Inbox","Comments", "Settings", "Edit profile", "Upgrade", "Terms & Conditions", "Privacy Statement", "Contact Us", "Logout", "Delete Account"]
    var selectedMenuItem : Int?
    var countClickCell: Int = 0
    
    //MARK: - ViewLifeCycles
    ///funcrion ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
//        addDeleteButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.backgroundColor = UIColor(hexString: "0a1533")
        tableView.frame = CGRect(x: 0, y: 85, width: view.frame.width, height: view.frame.height)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Private Variable
    private func addDeleteButton(){
        let button = UIButton(frame: CGRect(x: 15, y: view.frame.height - 200, width: 170, height: 50))
        button.backgroundColor = .white
        button.setTitleColor(UIColor.redColor(), for: .normal)
        button.setTitleColor(UIColor.redColor(), for: .selected)
        button.titleLabel?.font =  UIFont.sfProTextSemibold(size: 18)
        button.contentHorizontalAlignment = .left
        button.setTitle("Delete Account", for: .normal)
        button.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    
    //MARK: - Api
    func logOutApi(){
        self.selectedMenuItem = nil
        self.tableView.reloadData()
        let alert = UIAlertController.init(title: "Alert", message: "Do you sure you want to LogOut", preferredStyle: .alert)
        let done = UIAlertAction.init(title: "YES", style: .default) { (alert) in
            self.logoutAction()
        }
        let cancel = UIAlertAction.init(title: "NO", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    func logoutAction(){
        standard.set(nil, forKey: "paymentStatus")
        ApiInteraction.sharedInstance.onlineApi(status: false)
        AppState.UserAuth.authToken = nil
        AppState.presentLogin()
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    @objc func deleteAccount(){
        self.selectedMenuItem = nil
        self.tableView.reloadData()
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DeleteAccount") as! DeleteAccountDialogViewController
        
        vc.modalPresentationStyle = .overFullScreen
        vc.dialogDelegate = self
        
        let popover = vc.popoverPresentationController
        popover?.sourceView = self.view
        popover?.sourceRect = self.view.bounds
        popover?.delegate = self as? UIPopoverPresentationControllerDelegate
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true, completion:nil)
//
//        let alert = UIAlertController.init(title: "Alert", message: "Do you sure you want to delete your account", preferredStyle: .alert)
//        let done = UIAlertAction.init(title: "YES", style: .default) { (alert) in
//
//        }
//        let cancel = UIAlertAction.init(title: "NO", style: .cancel, handler: nil)
//        alert.addAction(cancel)
//        alert.addAction(done)
//        self.present(alert, animated: true, completion: nil)
    }
    func deleteAction(){
        let param = ["userID": standard.string(forKey: "userId") ?? ""]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "DeleteAccount", param: param, header: [:], success: { (json) in
            print(json)
            self.view.stopProgresshub()
            ApiInteraction.sharedInstance.onlineApi(status: false)
            standard.set(nil, forKey: "userId")
            AppState.UserAuth.authToken = nil
            AppState.presentLogin()
            GIDSignIn.sharedInstance()?.signOut()
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    // MARK: - Table view data source & TableView Delegates -
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.textColor = UIColor.white
            let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        cell!.textLabel?.text = menu[indexPath.row]
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.font = UIFont.sfProTextSemibold(size: 18)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row: \(indexPath.row)")
        if indexPath.row == selectedMenuItem {
                self.hideSideMenuView()
            return
        }
        selectedMenuItem = indexPath.row
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        switch (indexPath.row) {
        case 0:
            DispatchQueue.main.async {
                let destVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                destVC.model.removeAll()
                self.sideMenuController()?.setContentViewController(destVC)
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            break
        case 1:
            DispatchQueue.main.async {
                let destVC = mainStoryboard.instantiateViewController(withIdentifier: "IndexVC") as! InboxViewController
                self.sideMenuController()?.setContentViewController(destVC)
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            break
        case 2:
            DispatchQueue.main.async {
                let commentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
                commentVC.receiverId = standard.string(forKey: "userId") ?? ""
                //        commentVC.blockStatus = true
                
                self.sideMenuController()?.setContentViewController(commentVC)
                self.navigationController?.pushViewController(commentVC, animated: true)
            }
            break
        case 3:
        DispatchQueue.main.async {
            let destVC = mainStoryboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingsViewController
            self.sideMenuController()?.setContentViewController(destVC)
            self.navigationController?.pushViewController(destVC, animated: true)
           
            }
            break
        case 4:
            DispatchQueue.main.async {
                let destVC = mainStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
                self.sideMenuController()?.setContentViewController(destVC)
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            break
        case 5:
            guard !standard.bool(forKey: "paymentStatus") else{
                selectedMenuItem = nil
                self.showalert(msg: "Already Upgraded")
                self.tableView.reloadData()
                return
            }
            DispatchQueue.main.async {
                let destVC = mainStoryboard.instantiateViewController(withIdentifier: "UpgradeViewController") as! UpgradeViewController
                self.sideMenuController()?.setContentViewController(destVC)
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            break
        case 6:
           // destVC = mainStoryboard.instantiateViewController(withIdentifier: "WebNCID") as! WebViewController
            let destVC = mainStoryboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
            destVC.getDataURL = "\(baseURL)Home/termsofservices"
            sideMenuController()?.setContentViewController(destVC)
            self.navigationController?.pushViewController(destVC, animated: true)
            break
        case 7:
            let destVC = mainStoryboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
            destVC.getDataURL = "\(baseURL)Home/privacypolicy" //"https://www.hackingwithswift.com/articles/126/whats-new-in-swift-5-0"
            sideMenuController()?.setContentViewController(destVC)
            self.navigationController?.pushViewController(destVC, animated: true)
            break
        case 8:
            let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            sideMenuController()?.setContentViewController(desVC)
            self.navigationController?.pushViewController(desVC, animated: true)
            break
        case 9:
            self.logOutApi()
//            LoginManager().logOut()
            break
        case 10:
            self.deleteAccount()
            break
        default:
            break
        }
    }
}
extension MenuViewController: DeleteAccountDialogDelegate {
    func deleteAccountDialogViewController(_ deleteAccountDialog: DeleteAccountDialogViewController, selected result: Int) {
        switch result {
        case 0:
            print("disable search")
        case 1:
            print("hide account")
        case 2:
            print("clear contents")
        case 3:
            print("notification off")
        case 4:
            logoutAction()
        case 5:
            deleteAction()
        default:
            break
        }
        hideSideMenuView()
    }
    
    
}
