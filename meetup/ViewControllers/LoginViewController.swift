//
//  LoginViewController.swift
//  meetup
//
//  Created by An Phan on 3/21/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import AETextFieldValidator
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Alamofire
import SwiftyJSON
import IQKeyboardManager

class LoginViewController: UIViewController, UITextFieldDelegate
{
    // MARK: - IBOutlet
    @IBOutlet weak var userNameTextField: AETextFieldValidator!
    @IBOutlet weak var passwordTextField: AETextFieldValidator!
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var gmailButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var forgotPwdButton: UIButton!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        prepareTextField()
        prepareUIView()
        self.userNameTextField.addRegx(usernameRegex, withMsg: "UserName cannot be empty and also cannot contain Spaces")
        self.passwordTextField.addRegx(passwordRegex, withMsg: "Password must contain alpha numeric characters.")
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        IQKeyboardManager.shared().isEnabled = true
    }
    
    //MARK: - Private Functions
    private func prepareTextField()
    {
        let font = UIFont.sfProTextRegular(size: 16)
        let placeholderColor = UIColor.mainColor()
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        userNameTextField.font = font
        passwordTextField.font = font
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func prepareUIView()
    {
        if Is_Iphone6Plus
        {
            contentViewHeightConstraint.constant = 716
        }
        if Is_Iphone6
        {
            contentViewHeightConstraint.constant = 647
        }
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonAction(_ sender: UIButton)
    {
        if userNameTextField.validate() && passwordTextField.validate(){
            self.loginApi(loginType: "manual", url: mainURL)
            
        }
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func gmailButtonAction(_ sender: UIButton)
    {
        self.view.startProgressHub()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButtonAction(_ sender: UIButton)
    {
        self.getFacebookUserInfo()
    }
    
    @IBAction func forgotPwdButtonAction(_ sender: UIButton)
    {
    }
    
    //MARK: - API's
    //function to loginApi
    func loginApi(loginType: String,url: String){
        let param : Parameters
        var url : String?
        if loginType == "manual"{
            param  =  [
                "userName" : (userNameTextField.text ?? "").replacingOccurrences(of: " ", with: ""),
                "Password" : passwordTextField.text ?? "",
            ]
            url = apiURL + "login"
        }
        else{
            param  =  [
                "username": (user_name ?? "").replacingOccurrences(of: " ", with: ""),
                "email": email ?? "",
                "socialid": social_id ?? "",
                "image": image ?? ""
            ]
            url = apiURL + "socialLogin"
        }
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: url ?? "", param: param, header: [:], success: { (json) in
            print(json)
            self.view.stopProgresshub()
            if json["status"].intValue == 1{
                AppState.UserAuth.authToken = "Login"
                standard.set(json["data"]["user_id"].stringValue, forKey: "userId")
                standard.set(json["data"]["profilePic"].stringValue, forKey: "userImage")
                standard.set(json["data"]["userName"].stringValue, forKey: "userName")
                standard.set((json["data"]["paymentStatus"].stringValue == "0") ? false : true, forKey: "paymentStatus")
                self.dismiss(animated: false, completion: nil)
                ApiInteraction.sharedInstance.onlineApi(status: true)
                AppState.setHome()
            }else{
                self.showalert(msg: json["message"].stringValue)
            }
        }) { (error) in
            self.view.stopProgresshub()
            print(error)
        }
    }
    
    //function for login with facebook
    func getFacebookUserInfo(){
        let loginManager = LoginManager()
        self.view.startProgressHub()
        if let currentAccessToken = AccessToken.current, currentAccessToken.appID != Settings.appID
        {
            loginManager.logOut()
        }
        loginManager.logIn(permissions: [ "public_profile", "email" ], from: self) { loginResult, error in
            if error != nil {
                self.view.stopProgresshub()
                print(error.debugDescription)
            }
            else {
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = GraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    self.view.stopProgresshub()
                    let info = result as! [String : AnyObject]
                    print(info["name"] as! String)
                    user_name = info["name"] as? String ?? ""
                    email = info["email"] as? String ?? ""
                    social_id = info["id"] as? String ?? ""
                    image = ((info["picture"] as! [String: Any])["data"] as! [String: Any])["url"] as? String ?? ""
                    self.loginApi(loginType: "Social", url: SocialUrl)
                }
                Connection.start()
            }
            
        }
        /*
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result{
            case .cancelled:
                self.view.stopProgresshub()
                print("Cancel button click")
            case .success:
                
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = GraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    self.view.stopProgresshub()
                    let info = result as! [String : AnyObject]
                    print(info["name"] as! String)
                    user_name = info["name"] as? String ?? ""
                    email = info["email"] as? String ?? ""
                    social_id = info["id"] as? String ?? ""
                    image = ((info["picture"] as! [String: Any])["data"] as! [String: Any])["url"] as? String ?? ""
                    self.loginApi(loginType: "Social", url: SocialUrl)
                }
                Connection.start()
            default:
                self.view.stopProgresshub()
                print("??")
            }
        }*/
    }
}

//MARK: - GoogleSignInDelegates and DataSource -
extension LoginViewController : GIDSignInDelegate{   //GIDSignInUIDelegate
    ///function for google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            //                        user_name = user.userID                  // For client-side use only!
            social_id = user.authentication.idToken // Safe to send to the server
            user_name = user.profile.name
            email = user.profile.email
            
            image = "\(user.profile.imageURL(withDimension: 30) ?? URL(string: "")!)"
            self.loginApi(loginType: "Social", url: SocialUrl)
            // ...
        }
        self.view.stopProgresshub()
    }
}
