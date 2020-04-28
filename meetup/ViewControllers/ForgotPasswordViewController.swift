//
//  ForgotPasswordViewController.swift
//  meetup
//
//  Created by An Phan on 3/26/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//
import UIKit
import Alamofire
import AETextFieldValidator

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: AETextFieldValidator!
    
    //MARK: - ViewLifeCylce
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Look Listen & Feel"
        navigationController?.isNavigationBarHidden = false
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        emailTextField.addRegx(emailRegx, withMsg: "Please enter valid EMail")
        gradientOfNavigationBar()
        prepareTextField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTextField.resignFirstResponder()
    }
    
    //MARK: - Private Functions
    private func prepareTextField() {
        let font = UIFont.sfProTextRegular(size: 16)
        let placeholderColor = UIColor.mainColor()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
    }

    //MARK: - Actions
    @IBAction func send(_ sender: Any) {
        if emailTextField.validate(){
            self.forgotPaswrdApi()
        }
    }
    
    //MARK: - Api's
    ///function Api for forgot Password.
    func forgotPaswrdApi(){
        let param : Parameters = ["email": emailTextField.text ?? ""]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "forgotPassword", param: param as [String: Any], header: [:], success: { (json) in
            print(json)
            self.view.stopProgresshub()
            self.showalert(msg: json["message"].stringValue)
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
            //for testing purpose
            self.showalert(msg: "Email has been sent to you. Please check")
        }
    }
}
