//
//  ContactUsViewController.swift
//  meetup
//
//  Created by developer on 30/05/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContactUsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var txtViewHeight: NSLayoutConstraint!
    
    // MARK: - Private var/let
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = "Write a Message..."
        self.textView.textColor = UIColor.lightGray
        self.textView.delegate = self
        self.txtViewHeight.constant = 100
        self.textView.layer.borderColor = UIColor.gray.cgColor
        self.textView.layer.borderWidth = 0.5
        self.setUpNav()
        prepareGradient()
        addTapGeture()
        addSwipeGeture()
        self.sideMenuController()?.sideMenu?.delegate = self
    }
    
    //MARK: - Other Functions
    ///function to set navigation Bar on screen
    func setUpNav(){
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationController?.isToolbarHidden = true
        let rightbtn = UIBarButtonItem(image: #imageLiteral(resourceName: "more-icon"), style: .done, target: self, action: #selector(moreBarButtonAction(_:)))
        navigationItem.rightBarButtonItems = [rightbtn]
        title = " Contact Us"
    }
    
    //MARK: - @objc Methods
    /// function when main View is Tapped, hides Menu if open.
    @objc func mainViewTapped(swipe: UISwipeGestureRecognizer) {
        hideSideMenuView()
        hideMenuOption()
    }
    ///function to do action on right NavigationBar Button is tapped
    @objc func moreBarButtonAction(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    // MARK: - Private methods
    private func addTapGeture() {
        tapGeture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        tapGeture.isEnabled = false
        view.addGestureRecognizer(tapGeture)
    }
    
    private func addSwipeGeture() {
        swipeGeture = UISwipeGestureRecognizer(target: self, action: #selector(mainViewTapped))
        swipeGeture.isEnabled = false
        swipeGeture.direction = .right
        view.addGestureRecognizer(swipeGeture)
    }
    
    private func hideMenuOption() {
        //        collectionViewTrailingConstraint.constant = spacingOfCollectionView
        //        collectionViewLeadingConstraint.constant = spacingOfCollectionView
        UIView.animate(withDuration: 0.4) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func prepareGradient() {
        // Set gradient of navigationBar
        gradientOfNavigationBar()
    }
    
    //MARK: - IBAction
    ///button action to submit form
    @IBAction func submitAction(_ sender: Any) {
        guard self.textView.text != "Write a Message..." else{
            self.showalert(msg: "Please enter the Message:")
            return
        }
        self.submit()
    }
    
    //MARK: - API's
    ///function to submit form
    func submit(){
        let param: Parameters = ["message": self.textView.text ?? "",
                                 "userId": standard.string(forKey: "userId") as! String]             //standard.string(forKey: "userId") as! String
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "contact_us", param: param, header: [:], success: { (json) in
            print(json)
            self.showalert(msg: json["message"].stringValue)
            self.textView.text = "Write a Message..."
            self.textView.textColor = UIColor.lightGray
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.showalert(msg: error)
        }
    }
}
//MARK: - TextViewDelegates -
extension ContactUsViewController: UITextViewDelegate{
    ///function to check textView is begin
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textView.textColor == UIColor.lightGray{
            self.textView.text = ""
        }
        self.textView.textColor = UIColor.black
    }
    ///funtion to check textView changes
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height < 100{
            self.txtViewHeight.constant = 100
            self.textView.isScrollEnabled = false
        }else if (textView.contentSize.height < 200) && (textView.contentSize.height >= 100){
            self.txtViewHeight.constant = self.textView.contentSize.height
            self.textView.isScrollEnabled = true
        }else{
            self.textView.isScrollEnabled = true
            self.txtViewHeight.constant = 200
        }
    }
    ///function to check textView end typing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            self.textView.text = "Write a Message..."
            self.textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - ENSideMenuDelegate-
extension ContactUsViewController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        tapGeture.isEnabled = true
        swipeGeture.isEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func sideMenuWillClose() {
        tapGeture.isEnabled = false
        swipeGeture.isEnabled = false
        hideMenuOption()
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
}
