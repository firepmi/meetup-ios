//
//  EditProfileViewController.swift
//  meetup
//
//  Created by developer on 30/04/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LocationPickerViewController
import AVKit
import CoreLocation
import MobileCoreServices
import SDWebImage

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var jobLabel: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var lookingForTextfield: UITextField!
    @IBOutlet weak var longestRelationshipTextfield: UITextField!
    @IBOutlet weak var kidsTxtField: UITextField!
    @IBOutlet weak var TxtViewhobbies: UITextView!
    @IBOutlet weak var TxtViewHobbiesHeight: NSLayoutConstraint!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var instagramtextField: UITextField!
    @IBOutlet weak var facebooktextField: UITextField!
    @IBOutlet weak var googlePlustextField: UITextField!
    @IBOutlet weak var youtubetextField: UITextField!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var contentTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var textfieldArray: [UITextField]!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoPlayBtn: UIButton!
    @IBOutlet weak var videoImageHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    
    // MARK: - Variables
    var spacingOfScrollView: CGFloat = 15
    var model = ProfileModel.init(json: JSON(JSON.self))
    var picker = UIPickerView()
    var isType = ""
    var bodyArray = ["Skinny","Athletic","Average","Muscular","Slim","Thick"]
    var lookingArray = ["FriendShip","RelationShip"]
    var kidArray = ["No", "Yes, 1 Kid","Yes, 2 Kid","Yes, 3 Kid","Yes, 4 Kid"]
    var relationArray = ["1 year","2 year","3 year","4 year","5 year","More than 5 year"]
    var showVideo = false{
        didSet{
            if !showVideo{
                self.videoImageHeight.constant = 75
                self.videoImage.isHidden = true
                self.videoPlayBtn.isHidden = true
                self.recordButton.isHidden = false
            }else{
                self.videoImageHeight.constant = 120
                self.videoImage.isHidden = false
                self.videoPlayBtn.isHidden = false
                self.recordButton.isHidden = true
            }
        }
    }
    var videoPath: String?
    var uploadProfile : Bool?
    var datePicker = UIDatePicker()
    var videoURL: String?
    let locationPicker = LocationPicker()
    var lat : Double?
    var long : Double?
    
    // MARK: - Private var/let
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    fileprivate var imagePickerController = UIImagePickerController()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Look Listen & Feel"
        
        showVideo = false
        showdatePicker()
        // Handle side menu
        self.sideMenuController()?.sideMenu?.delegate = self
        // Set gradient of navigationBar
        gradientOfNavigationBar()
        addTapGeture()
        addSwipeGeture()
        prepareNavigationBar()
        DispatchQueue.main.async {
            self.fetchUserProfile()
        }
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden  = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideSideMenuView()
    }
    
    // MARK: - objc Methods
    @objc func moreBarButtonAction() {
        toggleSideMenuView()
    }
    
    @objc func mainViewTapped() {
        hideSideMenuView()
        hideMenuOption()
    }
    
    @objc func date(_ sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd yyyy"
        self.ageLabel.text = dateformatter.string(from: sender.date)
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
    
    private func hideMenuOption()
    {
        contentTrailingConstraint.constant = spacingOfScrollView
        contentLeadingConstraint.constant = spacingOfScrollView
        UIView.animate(withDuration: 0.4)
        {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
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
    
    //MARK: - Other Functions
    ///function to setup delegates and picker
    func setUp(){
        self.descriptionTextView.layer.borderWidth = 0.5
        self.descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.descriptionTextView.delegate = self
        self.descriptionHeight.constant = 65
        
        if descriptionTextView.text == ""{
            descriptionTextView.text = "Write Descriptions..."
            descriptionTextView.textColor = UIColor.lightGray
        }
        for i in textfieldArray{
            i.delegate = self
            i.inputView = picker
        }
        
        locationNameLabel.delegate = self
        self.picker.delegate = self
        self.picker.backgroundColor = UIColor.white
    }
    
    func showdatePicker(){
        self.datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = UIColor.white
        self.ageLabel.inputView = self.datePicker
        datePicker.addTarget(self, action: #selector(date), for: .valueChanged)
    }
    
    func loadData(){
        self.userNameLabel.text = self.model.userName ?? ""
        self.ageLabel.text = self.dateConverter(string: "\(self.model.DateOfBirth ?? "")")
        self.userImageView.sd_setImage(with: URL(string: self.model.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"), options: .refreshCached, progress: nil) { (image, error, cache, url) in
            if image != nil{
                self.userImageView.image = image
            }
            else{
                self.userImageView.image = #imageLiteral(resourceName: "profilePlaceholder")
            }
        }
        self.videoImage.sd_setImage(with: URL(string: self.model.videoImage ?? ""), placeholderImage: #imageLiteral(resourceName: "crop"), options: .refreshCached) { (image, error, cache, url) in
            if image != nil{
                self.videoImage.image = image
            }else{
                self.videoImage.image = #imageLiteral(resourceName: "crop")
            }
        }
        self.lookingForTextfield.text = self.model.lookingFor ?? ""
        self.longestRelationshipTextfield.text = self.model.longestRelationship ?? ""
        self.kidsTxtField.text = self.model.kids ?? ""
        self.descriptionTextView.text = ((self.model.Aboutme ?? "") != "") ? (self.model.Aboutme ?? "") : "Write Descriptions..."
        self.descriptionTextView.textColor = ((self.model.Aboutme ?? "") != "") ? UIColor.black : UIColor.gray
        self.jobLabel.text = self.model.bodyType ?? ""
        self.locationNameLabel.text = self.model.address ?? ""
        self.instagramtextField.text = self.model.instagramUrl ?? ""
        self.facebooktextField.text = self.model.facebookUrl ?? ""
        self.googlePlustextField.text = self.model.googleplusUrl ?? ""
        self.youtubetextField.text = self.model.youtubeUrl ?? ""
    }
    
    //MARK:- Actions
    @IBAction func saveAction(_ sender: Any) {
        guard (self.jobLabel.text ?? "") != "" else{
            self.showalert(msg: "Please Enter BodyType")
            return
        }
        showVideo = false
        self.saveApi()
    }
    
    @IBAction func recordButtonAction(_ sender: Any) {
        self.uploadProfile = false
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
    
    @IBAction func playVideoBtn(_ sender: Any) {
        let player = AVPlayer(url: URL(fileURLWithPath: videoPath ?? ""))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    @IBAction func uploadProfilePicAction(_ sender: Any) {
        self.uploadProfile = true
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: { action -> Void in
        })
        let photoAction = UIAlertAction(title: "From Photo Library", style: .default, handler: { action -> Void in
            self.checkForPhotosAccess()
        })
        let cameraRollAction = UIAlertAction(title: "Camera", style: .default, handler: { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.checkForCameraAccess()
            }
        })
        cameraRollAction.setValue(UIColor.red, forKey: "titleTextColor")
        imagePickerController.delegate = self
        imagePickerController.title = "UploadProfilePicker"
        if UIDevice.isPhone {
        self.showAlert("Choose your profile picture",
                       message: nil,
                       style: UIAlertController.Style.actionSheet,
                       actions: [cancelAction, cameraRollAction, photoAction])
        }
        else {
            self.showAlert("Choose your profile picture",
            message: nil,
            style: UIAlertController.Style.alert,
            actions: [cancelAction, cameraRollAction, photoAction])
        }
    }
    
   
    
    
    //MARK: - filePrivate Functions
    fileprivate func checkForCameraAccess() {
        
        self.imagePickerController.sourceType    = UIImagePickerController.SourceType.camera
        self.imagePickerController.allowsEditing = true
        DispatchQueue.main.async {
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
    }
    
    fileprivate func checkForPhotosAccess() {
            self.imagePickerController.sourceType    = UIImagePickerController.SourceType.photoLibrary
            self.imagePickerController.allowsEditing = true
            DispatchQueue.main.async {
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
    }
    
    //MARK:- Additional Functions
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
    
    func videoPreviewUiimage(fileName: String) -> UIImage? {
        
            let vidURL = URL(fileURLWithPath: fileName)
            let asset = AVAsset(url: vidURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
            do {
                let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
                return UIImage(cgImage: imageRef)
            }
            catch let error as NSError
            {
                print("Image generation failed with error \(error)")
                return nil
            }
    }
    
    func showAutoCompleteVC(){
        locationPicker.delegate = self
        locationPicker.mapView.isHidden = true
        locationPicker.searchBar.text = ""
        self.present(locationPicker, animated: true, completion: nil)
    }
    
    
    //MARK:- Api's
    ///function to fetchUserProfile
    func fetchUserProfile(){
        let param : Parameters = ["userID": standard.string(forKey: "userId") ?? ""]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "getuserProfile", param: param, header: [:], success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                self.model = ProfileModel.init(json: JSON(json["data"]["User"].dictionary ?? [:]))
                self.loadData()
            }else{
                self.showalert(msg: json["message"].stringValue)
            }
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    //function to save all data
    func saveApi(){
        let param: Parameters = [
            "userID": standard.string(forKey: "userId") ?? "",
                                 "UserName": userNameLabel.text ?? "",
                                 "OnlineStatus": "1",
                                 "Address": self.locationNameLabel.text ?? "",
                                 "AboutMe": (self.descriptionTextView.textColor == UIColor.black) ? ((self.descriptionTextView.text) ?? "") : "",
                                 "BodyType" : jobLabel.text ?? "",
                                 "DOB": ageLabel.text ?? "",
                                 "UserAge": ageLabel.text ?? "",
                                 "LookingFor" : lookingForTextfield.text ?? "",
                                 "LongestRelationship": longestRelationshipTextfield.text ?? "",
                                 "Kids": kidsTxtField.text ?? "",
                                 "Hobbies": (self.TxtViewhobbies.text ?? ""),
                                 "LikePercentage": "",
                                 "FavouritePercentage": "",
                                 "UnlikePercentage": "",
                                 "VedioUrl" : self.videoURL ?? "",
                                 "FacebookUrl" : self.facebooktextField.text ?? "",
                                 "InstagramUrl" : self.instagramtextField.text ?? "",
                                 "YoutubeUrl" : self.youtubetextField.text ?? "",
                                 "GoogleplusUrl" : self.googlePlustextField.text ?? "",
                                 "latitude" : "\(lat ?? 0.0)",
                                 "longitude" : "\(long ?? 0.0)"
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitTwoMultipartApi(url: apiURL + "updateuserProfile", param: param, header: [:], imageArray: [self.userImageView.image ?? UIImage()], imageName: ["profilePic"], videoImage: self.videoImage.image ?? #imageLiteral(resourceName: "crop"), videoImageName: "videoImage", success: { (json) in
            print(json)
            self.showalert(msg: json["message"].stringValue)
            standard.set(json["data"]["profilePic"].stringValue, forKey: "userImage")
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
            self.showalert(msg: error)
        }
    }
    
    
    ///function upload video url
    func uploadVideo(url: URL?){
        let param: Parameters = [
            "userID": standard.string(forKey: "userId") ?? "",
        ]
        print(param)
        self.view.startProgressHub()
        
        ApiInteraction.sharedInstance.funcToHitVideoMultipartApi(url: apiURL + "UploadVideo", param: param, header: [:], videoPath: url, videoName: "vedio", success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                self.videoURL = json["data"]["vedio"].stringValue
            }
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    ///function to fetch BodyTypes
    func bodyType(){
        let param: Parameters = ["" :""]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "", param: param, header: [:], success: { (json) in
            print(json)
            self.view.stopProgresshub()
        }) { (error) in
            self.view.stopProgresshub()
        }
    }
    
    //MARK:- textFieldDelegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == jobLabel{
            isType = "job"
            textField.text = self.bodyArray[0]
        }else if textField == lookingForTextfield{
            isType = "looking"
            textField.text = self.lookingArray[0]
        }
        else if textField == kidsTxtField{
            isType = "kid"
            textField.text = self.kidArray[0]
        }else if textField == longestRelationshipTextfield{
            isType = "relationship"
            textField.text = self.relationArray[0]
        }else if textField == locationNameLabel{
            textField.inputView = nil
            guard standard.bool(forKey: "paymentStatus") else{
                self.showalert(msg: "Please upgrade the app first.")
                return
            }
            self.showAutoCompleteVC()
        }
        self.picker.reloadAllComponents()
        self.picker.reloadInputViews()
    }
    
    
    //MARK:- ImagePickerDelegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if (self.uploadProfile ?? true){
            if let filePath = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // imageViewPic.contentMode = .scaleToFill
                self.userImageView.image = filePath
            }
        }else{
            if let filePath = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                // imageViewPic.contentMode = .scaleToFill
                let videoData : Data!
                do {
                    try videoData = Data(contentsOf: filePath as URL)
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let documentsDirectory = paths[0]
                    let tempPath = documentsDirectory.appendingFormat("/vid1.mp4")
                    let url = URL(fileURLWithPath: tempPath)
                    do {
                        try _ = videoData.write(to: url, options: [])
                    }catch{
                        print("ERROR")
                    }
                    self.videoPath = "\(filePath)"
                    DispatchQueue.main.async {
                        self.videoImage.image = self.videoPreviewUiimage(fileName: "\(filePath)")
                    }
                    self.showVideo = true
                    print(filePath)
                    self.uploadVideo(url: url)
                }catch {
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - textViewDelegates
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= 100{
            self.descriptionHeight.constant = 100
            textView.isScrollEnabled = true
        }else if textView.contentSize.height > 65 &&  textView.contentSize.height < 100{
            self.descriptionHeight.constant = textView.contentSize.height
            textView.isScrollEnabled = true
        }else if textView.contentSize.height <= 65{
            self.descriptionHeight.constant = 65
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.text == "Write Descriptions..."{
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Write Descriptions..."
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
}

extension EditProfileViewController : LocationPickerDelegate{
    func locationDidSelect(locationItem: LocationItem) {
        print("didSelect")
        print(locationItem.addressDictionary ?? [:])
//        print(locationItem.coordinate)
        self.lat = locationItem.coordinate?.latitude
        self.long = locationItem.coordinate?.longitude
        let dict = JSON(locationItem.addressDictionary ?? [:]).dictionaryValue
        self.locationNameLabel.text = (dict["Name"]?.stringValue ?? "") + "," + (dict["City"]?.stringValue ?? "")
        self.locationPicker.dismiss(animated: true) {
            print("Dismissed")
        }
    }
}

//MARK:- PickerDelegates
extension EditProfileViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       if isType == "job"{
            return bodyArray.count
        }else if isType == "looking"{
            return lookingArray.count
        }else if isType == "kid"{
            return 5
        }else if isType == "relationship"{
            return relationArray.count
       }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isType == "job"{
            return bodyArray[row]
        }else if isType == "looking"{
            return lookingArray[row]
        }else if isType == "kid"{
            return kidArray[row]
        }else if isType == "relationship"{
            return relationArray[row]
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isType == "job"{
            jobLabel.text = bodyArray[row]
        }else if isType == "looking"{
            lookingForTextfield.text = lookingArray[row]
        }else if isType == "kid"{
            kidsTxtField.text = kidArray[row]
        }else if isType == "relationship"{
            longestRelationshipTextfield.text = relationArray[row]
        }
    }
}

// MARK: - ENSideMenuDelegate
extension EditProfileViewController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        tapGeture.isEnabled = true
        swipeGeture.isEnabled = true
        contentTrailingConstraint.constant = (UIScreen.main.bounds.width * 7) / 10 + spacingOfScrollView
        contentLeadingConstraint.constant = -(UIScreen.main.bounds.width * 7) / 10 + spacingOfScrollView
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
