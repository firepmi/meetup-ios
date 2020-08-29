//
//  AppDelegate.swift
//  meetup
//
//  Created by An Phan on 3/21/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//
import UIKit
import Fabric
import Crashlytics
import IQKeyboardManager
import FBSDKCoreKit
import GoogleSignIn
//import GooglePlaces
import CoreLocation
import StoreKit
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    var location: CLLocationManager?
    class func shared() -> AppDelegate! {
        return UIApplication.shared.delegate as? AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
//        Fabric.with([Crashlytics.self])
        // Set light status bar
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Set IQKeyboardManager Keyboard
        IQKeyboardManager.shared().isEnabled = true
        
        configAppearance()
        
        //facebook login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
                
        //Google Login
        GIDSignIn.sharedInstance().clientID = "629599280221-j384daa9bhov9c78s2b7eet2c404ibaf.apps.googleusercontent.com"
        
        //Google Places
//        GMSPlacesClient.provideAPIKey("AIzaSyBVvX8nhZ3vJKDBOb7_W7hzegQAcjLT67Y")
        // AIzaSyA1M05TIgiht_OixAAtJ0ooT-Ong3RiEbs
//        AIzaSyA1M05TIgiht_OixAAtJ0ooT-Ong3RiEbs
        
       //LocationSetup
        location = CLLocationManager()
        location?.requestAlwaysAuthorization()
        
        location?.startUpdatingLocation()
                
        if !standard.bool(forKey: "welcome") {
            return true
        }
        // authen logic
        if AppState.UserAuth.isAuthenticated() {
            ApiInteraction.sharedInstance.onlineApi(status: true)
            AppState.setHome()
        }
        else {
            AppState.presentLogin()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        ApiInteraction.sharedInstance.onlineApi(status: false)
//        AppEventsLogger.activate(application)
        AppEvents.activateApp()
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let appId: String = SDKSettings.appId
//        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
//            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
//        }
////        return GIDSignIn.sharedInstance().handle(url as URL?,
////                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
////                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//        return GIDSignIn.sharedInstance().handle(url as URL?)
//    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appId: String = Settings.appID ?? ""
                if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
                    return ApplicationDelegate.shared.application(application, open: url, options: options)
                }
//                return GIDSignIn.sharedInstance().handle(url as URL?,
//                                                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                                                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
                return GIDSignIn.sharedInstance().handle(url as URL?)
        
//        let handled = ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
//        return handled
        
    }
    fileprivate func configAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.uniformBold(size: 22),
                                                    NSAttributedString.Key.foregroundColor: UIColor(hexString: "0a1533")]
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = UIColor.black
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -500, vertical: 0), for: .default)
    }
    
}
