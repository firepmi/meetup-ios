//
//  SignUpViewController.swift
//  meetup
//
//  Created by An Phan on 3/23/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import SwiftyJSON
import Alamofire
import CoreLocation
import AETextFieldValidator

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderButton: UIButton!
   
    @IBOutlet weak var userNameRoundView: RoundedView!
    @IBOutlet weak var ageRoundView: RoundedView!
    @IBOutlet weak var emailRoundView: RoundedView!
    @IBOutlet weak var passwordRoundView: RoundedView!
    
    var isMale = true
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Look Listen & Feel"
        // Side menu delegate
        self.sideMenuController()?.sideMenu?.delegate = self
        // Show navigation bar
//        navigationController?.isNavigationBarHidden = false
        navigationController?.setNavigationBarHidden(true, animated: false)
//        prepareGradient()
        prepareTextField()
//        showdatePicker()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide back button
        //navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }
    @IBAction func onGenderSwitched(_ sender: Any) {
        isMale = !isMale
        if(isMale) {
            genderButton.setImage(UIImage(named: "toggle_male.png"), for: .normal)
        }
        else {
            genderButton.setImage(UIImage(named: "toggle_female.png"), for: .normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - @Objc Methods
    @objc func moreBarButtonAction() {
        self.view.endEditing(true)
        toggleSideMenuView()
    }
    
//    @objc func date(_ sender: UIDatePicker){
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "MM/dd/yyyy"
//        self.birthDateTextField.text = dateformatter.string(from: sender.date)
//    }
    
    private func prepareNavigationBar() {
        // Added right bar button
//        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "more-icon"),
//                                                style: .plain,
//                                                target: self,
//                                                action: #selector(moreBarButtonAction))
//        navigationItem.rightBarButtonItem = moreBarButtonItem
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.sfProTextRegular(size: 17)
        let placeholderColor = UIColor.mainColor()
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
//        userNameTextField.addRegx(usernameRegex, withMsg: "UserName cannot be empty and aslo can't contain Spaces")
//        passwordTextField.addRegx(passwordRegex, withMsg: "Password must contain alpha number")
//        confirmTextField.addConfirmValidation(to: passwordTextField, withMsg: "Confirm Password doesn't match with Password")
//        emailTextField.addRegx(emailRegx, withMsg: "Please enter valid email")
//        userNameTextField.attributedPlaceholder = attributedString(placeHolder: "johnadams")
//        emailTextField.attributedPlaceholder = attributedString(placeHolder: "Email")
//        passwordTextField.attributedPlaceholder = attributedString(placeHolder: "Password")
//        confirmTextField.attributedPlaceholder = attributedString(placeHolder: "Confirm Password")
//        ageTextField.attributedPlaceholder = attributedString(placeHolder: "Number between 18 to 80")
        userNameTextField.placeholder = "johnadams"
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
//        confirmTextField.placeholder = "Confirm Password"
        ageTextField.placeholder = "Number between 18 to 80"
    }
    
//    fileprivate func checkForCameraAccess() {
//        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
//        switch authorizationStatus {
//        case .notDetermined:
//            // permission dialog not yet presented, request authorization
//
//            AVCaptureDevice.requestAccess(for: AVMediaType.video,
//                                          completionHandler: { (granted:Bool) -> Void in
//                if granted {
//                    print("access granted")
//                    self.imagePickerController.sourceType    = UIImagePickerController.SourceType.camera
//                    self.imagePickerController.allowsEditing = true
//                    DispatchQueue.main.async {
//                        self.present(self.imagePickerController, animated: true, completion: nil)
//                    }
//                }
//                else {
//                    print("access denied")
//                    //self.presentNoMediaPermissionPage()
//                }
//            })
//        case .authorized:
//            print("Access authorized")
//            self.imagePickerController.sourceType    = UIImagePickerController.SourceType.camera
//            self.imagePickerController.allowsEditing = true
//            DispatchQueue.main.async {
//                self.present(self.imagePickerController, animated: true, completion: nil)
//            }
//        case .denied, .restricted:
//            print("Denied Restricted")
//        @unknown default:
//            print("unknown issue")
//        }
//    }
    
//    fileprivate func checkForPhotosAccess() {
//        let status = PHPhotoLibrary.authorizationStatus()
//        switch status {
//        case .authorized:
//            // handle authorized status
//            print("Authorized")
//            self.imagePickerController.sourceType    = UIImagePickerController.SourceType.photoLibrary
//            self.imagePickerController.allowsEditing = true
//            DispatchQueue.main.async {
//                self.present(self.imagePickerController, animated: true, completion: nil)
//            }
//        case .denied, .restricted :
//            // handle denied status
//            print("Denied, Restricted")
//            //self.presentNoMediaPermissionPage()
//            break
//        case .notDetermined:
//            // ask for permissions
//            print("NotDetermined")
//            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
//                switch status {
//                case .authorized:
//                    // as above
//                    self.imagePickerController.sourceType    = UIImagePickerController.SourceType.photoLibrary
//                    self.imagePickerController.allowsEditing = true
//                    DispatchQueue.main.async {
//                        self.present(self.imagePickerController, animated: true, completion: nil)
//                    }
//                case .denied, .restricted:
//                    // as above
//                    //                    self.presentNoMediaPermissionPage()
//                    break
//                case .notDetermined: break
//                    // won't happen but still
//                @unknown default:
//                    fatalError()
//                    break
//                }
//            }
//        @unknown default:
//            fatalError()
//        }
//    }
    
//    func showdatePicker(){
//        self.datePicker.datePickerMode = .date
//        datePicker.maximumDate = Date()
//        datePicker.backgroundColor = UIColor.white
//        self.birthDateTextField.inputView = self.datePicker
//        datePicker.addTarget(self, action: #selector(date), for: .valueChanged)
//    }
    
   
    
    // MARK: - IBAction
    
//    @IBAction func uploadPictureButtonAction(_ sender: UIButton) {
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: { action -> Void in
//        })
//        let photoAction = UIAlertAction(title: "From Photo Library", style: .default, handler: { action -> Void in
//            self.checkForPhotosAccess()
//        })
//        let cameraRollAction = UIAlertAction(title: "Camera", style: .default, handler: { action -> Void in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                self.checkForCameraAccess()
//            }
//        })
//        cameraRollAction.setValue(UIColor.red, forKey: "titleTextColor")
//        imagePickerController.delegate = self
//        if UIDevice.isPhone {
//            self.showAlert("Choose your profile picture",
//                       message: nil,
//                       style: UIAlertController.Style.actionSheet,
//                       actions: [cancelAction, cameraRollAction, photoAction])
//        }
//        else {
//            self.showAlert("Choose your profile picture",
//            message: nil,
//            style: UIAlertController.Style.alert,
//            actions: [cancelAction, cameraRollAction, photoAction])
//        }
//    }
//
    @IBAction func registerButtonAction(_ sender: UIButton) {
        if userNameTextField.text!.count == 0 {
            userNameRoundView.borderColor = .red
            return
        }
        else {
            userNameRoundView.borderColor = .lightGray
        }
        if ageTextField.text!.count == 0 {
            ageRoundView.borderColor = .red
            return
        }
        else {
            ageRoundView.borderColor = .lightGray
        }
        if emailTextField.text!.count == 0 {
            emailRoundView.borderColor = .red
            return
        }
        else {
            emailRoundView.borderColor = .lightGray
        }
        if passwordTextField.text!.count == 0 {
            passwordRoundView.borderColor = .red
            return
        }
        else {
            passwordRoundView.borderColor = .lightGray
        }
        self.signUp()
        
    }
    
    
    //MARK: - API's
    func signUp(){
        let param : Parameters = ["Username": userNameTextField.text ?? "",
                 "email": emailTextField.text ?? "",
                 "Password": passwordTextField.text ?? "",
                 "Gender": (self.isMale) ? "male" : "female",
                 "DateofBirth": ageTextField.text ?? "",
                 "latitude" : "\(CLLocationManager().location?.coordinate.latitude ?? 0.0)",
            "longitude" : "\(CLLocationManager().location?.coordinate.latitude ?? 0.0)"]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "register", param: param, header: [:], success: { (json) in
            print(json)
             self.view.stopProgresshub()
            if json["status"].intValue == 1{
                self.showalert(msg: json["message"].stringValue){
                    AppState.UserAuth.authToken = "Login"
                    AppState.presentLogin()
                }
            }else{
                self.showalert(msg: json["message"].stringValue)
            }
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
}

// MARK: - ENSideMenuDelegate -
extension SignUpViewController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func sideMenuWillClose() {
        view.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
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
