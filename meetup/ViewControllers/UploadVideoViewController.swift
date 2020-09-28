//
//  UploadVideoViewController.swift
//  meetup
//
//  Created by mobileworld on 8/31/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Alamofire
import SwiftyJSON

class UploadVideoViewController: UIViewController
{    
    @IBOutlet weak var annoteLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var titleTextField: RoundedTextField!
    @IBOutlet weak var descriptionTextView: RoundedTextView!
    var videoPath: String?
    var url:URL?
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Look Listen & Feel"
        
        self.sideMenuController()?.sideMenu?.delegate = self
        // Set gradient of navigationBar
        gradientOfNavigationBar()
        addTapGeture()
        addSwipeGeture()
        prepareNavigationBar()
    }
    @IBAction func onNewVideo(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Video From", message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Record Video", style: .default) { (alert) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Select Video", style: .default) { (alert) in
            self.openGallery()
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSave(_ sender: Any) {
        if titleTextField.text?.count == 0 {
            showalert(msg: "Please add the video title")
            return
        }
        self.uploadVideo(url: url)
//        dismiss(animated: true, completion: nil)
    }
    func uploadVideo(url: URL?){
        let param: Parameters = [
            "userID": standard.string(forKey: "userId") ?? "",
            "title" : titleTextField.text!,
            "description" : descriptionTextView.text!
        ]
        print(param)
        self.view.startProgressHub()
        
        ApiInteraction.sharedInstance.funcToHitVideoMultipartApi(url: apiURL + "UploadVideo", param: param, header: [:], videoPath: url, videoName: "vedio", success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                self.dismiss(animated: true, completion: nil)
            }
            self.view.stopProgresshub()
        }, progressUpdate: { value in
            self.percentLabel.text = "\(Int(value))% Completed"
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    // MARK: - Private methods
    private func addTapGeture() {
        tapGeture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        tapGeture.isEnabled = false
        view.addGestureRecognizer(tapGeture)
    }
    
    private func addSwipeGeture()
    {
        swipeGeture = UISwipeGestureRecognizer(target: self, action: #selector(mainViewTapped))
        swipeGeture.isEnabled = false
        swipeGeture.direction = .right
        view.addGestureRecognizer(swipeGeture)
    }
    private func prepareNavigationBar()
    {
        // Added right bar button
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "more-icon"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(moreBarButtonAction))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    @objc func moreBarButtonAction() {
        toggleSideMenuView()
    }
    
    @objc func mainViewTapped() {
        hideSideMenuView()
        hideMenuOption()
    }
}
extension UploadVideoViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            print("Camera Available")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera UnAvaialable")
        }
    }
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            print("Gallery Available")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            imagePicker.mediaTypes = ["public.movie"]
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("Gallery UnAvailable")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let filePath = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                // imageViewPic.contentMode = .scaleToFill
                let videoData : Data!
                do {
                    try videoData = Data(contentsOf: filePath as URL)
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let documentsDirectory = paths[0]
                    let tempPath = documentsDirectory.appendingFormat("/vid1.mp4")
                    let url = URL(fileURLWithPath: tempPath)
                    self.url = url
                    do {
                        try _ = videoData.write(to: url, options: [])
                    }catch{
                        print("ERROR")
                    }
                    self.videoPath = "\(filePath)"
                    DispatchQueue.main.async {
//                        self.videoImage.image = self.videoPreviewUiimage(fileName: "\(filePath)")
                    }
                    print(filePath)
                }catch {
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
}

// MARK: - ENSideMenuDelegate
extension UploadVideoViewController: ENSideMenuDelegate {
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
    private func hideMenuOption()
    {
        UIView.animate(withDuration: 0.4)
        {
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
