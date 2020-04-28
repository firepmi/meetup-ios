//
//  UpgradeViewController.swift
//  meetup
//
//  Created by developer on 03/06/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import StoreKit

class UpgradeViewController: UIViewController {

    // MARK: - Private var/let
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
//    let productID = "com.Developer.LifeGamess.Ultimate"
    var products: [SKProduct] = []
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpNav()
        prepareGradient()
        addTapGeture()
        addSwipeGeture()
        self.sideMenuController()?.sideMenu?.delegate = self
        fetchproducts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRestorePurchaseNotification(_:)),
                                               name: .IAPHelperRestorePurchaseNotification,
                                               object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchproducts()
    }
    //MARK: - Other Functions
    ///function to set navigation Bar on screen
    func setUpNav(){
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationController?.isToolbarHidden = true
        let rightbtn = UIBarButtonItem(image: #imageLiteral(resourceName: "more-icon"), style: .done, target: self, action: #selector(moreBarButtonAction(_:)))
        navigationItem.rightBarButtonItems = [rightbtn]
        title = " Upgrade"
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
    
    //MARK: - Buttons Action
    @IBAction func UpgrateToPrimiumAction(_ sender: UIButton) {
//        self.view.startProgressHub()
        self.hideSideMenuView()
//        self.purchase(productID: productID)
//        self.paymentApi()
        guard
        let index = products.firstIndex(where: { product -> Bool in
            product.productIdentifier == SubscriptionProducts.subscriptionID
        })
        else { return }
        SubscriptionProducts.store.buyProduct(self.products[index])
    }
    
    @IBAction func restorePrimiun(_ sender: Any) {
//        self.restorePurchases()
        SubscriptionProducts.store.restorePurchases()
    }
    
    //MARK:- InApp Purchase Methods
    func fetchproducts(){
//        let productIDs = Set([productID])
//        let request = SKProductsRequest(productIdentifiers: productIDs)
//        request.delegate = self
//        request.start()
        
        SubscriptionProducts.store.requestProducts({ [weak self] success, products in
            guard self != nil else { return }
            if success {
                print("Products count: \(products!.count)")
                self!.products = products!
                let isPro = SubscriptionProducts.store.isProductPurchased(SubscriptionProducts.subscriptionID)
                standard.set(isPro, forKey: "paymentStatus")
                print(SubscriptionProducts.subscriptionID, isPro)
            }
        })
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            let index = products.firstIndex(where: { product -> Bool in
                product.productIdentifier == productID
            })
            else { return }
        let isPro = SubscriptionProducts.store.isProductPurchased(SubscriptionProducts.subscriptionID)
        if isPro {
            //TODO: Add here
            let alert = UIAlertController(title: "Premium Membership", message: "Successfully Upgraded to Premium Membership!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                self.paymentApi(status: "1")
                standard.set(isPro, forKey: "paymentStatus")
            }))
            self.present(alert, animated: true);
        }
    }
    @objc func handleRestorePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            let index = products.firstIndex(where: { product -> Bool in
                product.productIdentifier == productID
            })
            else { return }
        let isPro = SubscriptionProducts.store.isProductPurchased(SubscriptionProducts.subscriptionID)
        if isPro {
            //TODO: add here
            let alert = UIAlertController(title: "Premium Membership", message: "Successfully Restored to Premium Membership!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                self.paymentApi(status: "1")
                standard.set(isPro, forKey: "paymentStatus")
            }))
            self.present(alert, animated: true);
        }
        else {
            let alert = UIAlertController(title: "Premium Membership", message: "Restored your purchase Successful but could not find the record you purchased before ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                
            }))
            self.present(alert, animated: true);
        }
    }
        
    //MARK: - Api's
    ///function to save payment status in database.
    func paymentApi(status: String){
        let param: Parameters = [
            "userID" : standard.string(forKey: "userId") ?? "",
            "PaymentStatus" : status
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "PaymentStatus", param: param, header: [:], success: { (json) in
            print(json)
            self.view.stopProgresshub()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            let destVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            destVC.model.removeAll()
            self.hideSideMenuView()
            if let vc = self.sideMenuController()?.sideMenu?.menuViewController as? MenuViewController{
                vc.selectedMenuItem = 0
                vc.tableView.reloadData()
            }
            if status == "1" {
                standard.set(true, forKey: "paymentStatus")
            }
            else {
                standard.set(true, forKey: "paymentStatus")
            }
            self.sideMenuController()?.setContentViewController(destVC)
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            let destVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            destVC.model.removeAll()
            
            if let vc = self.sideMenuController()?.sideMenu?.menuViewController as? MenuViewController{
                vc.selectedMenuItem = 0
                vc.tableView.reloadData()
            }
            self.sideMenuController()?.setContentViewController(destVC)
            self.view.stopProgresshub()
        }
    }
}
// MARK: - ENSideMenuDelegate-
extension UpgradeViewController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
//        self.hideSideMenuView()
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

////MARK:- InAppPurcahse Delegate -
//extension UpgradeViewController : SKProductsRequestDelegate{
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        response.invalidProductIdentifiers.forEach { product in
//            print("Invalid: \(product)")
//            self.showAlert("Alert", message: "Invalid: \(product)")
//
//        }
//        response.products.forEach { product in
//            print("Valid: \(product)")
//            products[product.productIdentifier] = product
//        }
//    }
//
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("Error for request: \(error.localizedDescription)")
//    }
//}
