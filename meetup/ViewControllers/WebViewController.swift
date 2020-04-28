//
//  WebViewController.swift
//  meetup
//
//  Created by An Phan  on 3/29/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import AVFoundation
import ARKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    // MARK: - Variable
    var getDataURL: String?
    var testPush: String?
    
    // MARK: - Private var/let
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    private var webView: WKWebView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Look Listen & Feel"
        self.sideMenuController()?.sideMenu?.delegate = self
        prepareNavigationBar()
        settupLoadview()
        addTapGeture()
        addSwipeGeture()
        navigationController?.isToolbarHidden = false
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    deinit {
        navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Private Methods
    private func addTapGeture() {
        tapGeture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        tapGeture.isEnabled = false
        tapGeture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGeture)
    }
    
    private func addSwipeGeture() {
        swipeGeture = UISwipeGestureRecognizer(target: self, action: #selector(mainViewTapped))
        swipeGeture.isEnabled = false
        swipeGeture.direction = .right
        view.addGestureRecognizer(swipeGeture)
    }
    
    private func settupLoadview() {
        let myURL = URL(string: getDataURL!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
    }
    
    internal func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    }
    
    private func prepareNavigationBar() {
        // Added right bar button
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "more-icon"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(moreBarButtonAction))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    // MARK: - @objc Methods
    @objc func mainViewTapped(swipe: UISwipeGestureRecognizer) {
        hideSideMenuView()
    }
    
    @objc func popViewController(){
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
//        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
//        sideMenuController()?.setContentViewController(destVC)
    }
    
    @objc func moreBarButtonAction() {
        toggleSideMenuView()
    }
}

 // MARK: - WKNavigationDelegate -
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Page loaded successfully")
        self.view.stopProgresshub()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Loading....")
        self.view.startProgressHub()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.view.stopProgresshub()
    }
    
    func close() {
        dismiss(animated: true)
    }
}

 // MARK: - ENSideMenuDelegate -
extension WebViewController: ENSideMenuDelegate{
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
    }
    
   
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func sideMenuDidClose() {
        
    }
    
    func sideMenuDidOpen() {
       
    }
}
