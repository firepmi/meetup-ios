//
//  Appstate.swift
//  meetup
//
//  Created by An Phan on 3/24/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit

struct AppState {
    static func logout() {
        UserDefaults.standard.removeObject(forKey: "com.meetup.user")
    }
    
    static func clearSessionUser() {
        UserAuth.authToken = nil
    }
    
    // Authentication
    struct UserAuth {
        static var defaults: UserDefaults! {
            return UserDefaults.standard
        }
        
        static func isAuthenticated() -> Bool {
            return authToken?.isEmpty == false
        }
        
        static let authTokenKey: String = "AppState.UserAuth.authToken"
        
        // Current session user token
        static var authToken: String? {
            get {
                return defaults.object(forKey: authTokenKey) as! String?
            }
            set {
                if (newValue == nil) {
                    defaults.removeObject(forKey: authTokenKey)
                } else {
                    defaults.set(newValue, forKey: authTokenKey)
                }
                defaults.synchronize()
            }
        }
    }
    
    static func presentLogin(animated: Bool = false) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNC")
        if animated {
            UIApplication.topViewController()?.present(loginVC,
                                                       animated: animated,
                                                       completion: {
                // Make sure to reset to the home page.
                if let nc = AppDelegate.shared().window?.rootViewController as? UINavigationController {
                    nc.popToRootViewController(animated: false)
                }
            })
        }
        else {
            loginVC.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(loginVC,
                                                       animated: animated,
                                                       completion: nil)
        }
    }
    
    static func setHome() {
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNC")
        guard let snapshot = AppDelegate.shared().window?.snapshotView(afterScreenUpdates: true) else {
            return
        }
        homeVC.view.addSubview(snapshot)
        AppDelegate.shared().window?.rootViewController = homeVC
        UIView.transition(with: snapshot, duration: 0.2, options: .transitionCrossDissolve, animations: {
            snapshot.layer.opacity = 0.0
        }) { (finished) in
            snapshot.removeFromSuperview()
        }
    }
    
    static func dismissSignInAnimated(animated: Bool = true) {
        UIApplication.topViewController()?.dismiss(animated: animated, completion: nil)
    }
    
    static func openURL(app: String,userName: String){
        var appURL : URL?
        var webURL : URL?
        if app == "Instagram"{
             appURL = URL(string:  "instagram://user?username=\(userName)")
             webURL = URL(string:  "https://instagram.com/\(userName)")
        }else if app == "Facebook"{
            appURL = URL(string:  "fb://profile/\(userName)")
            webURL = URL(string:  "https://www.facebook.com/\(userName)")
        }else if app == "Googleplus"{
            appURL = URL(string:  "gplus://plus.google.com/+")
            webURL = URL(string:  "http://http://plus.google.com/")
        }else if app == "Youtube"{
            appURL = URL(string:  "youtube://www.youtube.com/results?search_query=")
            webURL = URL(string:  "https://www.youtube.com/results?search_query=")
        }
        
        
        if UIApplication.shared.canOpenURL(appURL!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL!)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(webURL!)
            }
        }
    }
}
