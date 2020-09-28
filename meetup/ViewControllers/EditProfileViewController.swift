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
import PinterestLayout

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UITextField!
    @IBOutlet weak var contentTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hobbiesTextView: UITextView!
    @IBOutlet weak var longestRelationshipLabel: UILabel!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var bodyTypeLabel: UILabel!
    @IBOutlet weak var kidLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var unLikeLabel: UILabel!
    @IBOutlet weak var userImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Variables
    var spacingOfScrollView: CGFloat = 15
    var model = ProfileModel.init(json: JSON(JSON.self))
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    var isType = ""
    var bodyArray = ["Skinny","Athletic","Average","Muscular","Slim","Thick"]
    var lookingArray = ["FriendShip","RelationShip"]
    var kidArray = ["Single", "In a relationship","Engaged","Married",]
    var relationArray = ["1 year","2 year","3 year","4 year","5 year","More than 5 year"]

    @IBOutlet weak var ageSlider: AgeSlider!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var videoPath: String?
    var datePicker = UIDatePicker()
    var videoURL: String?
    let locationPicker = LocationPicker()
    var lat : Double?
    var long : Double?
    var images = [JSON]()
    var selectedMediaType = 0 // 0 - image profile, 1 - video, 2 - images
    var feetInchDelegate = FeetInchDelegate()
    // MARK: - Private var/let
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    fileprivate var imagePickerController = UIImagePickerController()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Look Listen & Feel"
        
//        showVideo = false
//        showdatePicker()
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
    func initPinterestLayout() {
        let layout = PinterestLayout()
        collectionView.collectionViewLayout = layout
        layout.delegate = self
        layout.cellPadding = 5
        layout.numberOfColumns = 2
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden  = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideSideMenuView()
    }
    override func viewDidAppear(_ animated: Bool) {
        getImages()
    }
    
    // MARK: - objc Methods
    @objc func moreBarButtonAction() {
        toggleSideMenuView()
    }
    
    @objc func mainViewTapped() {
        hideSideMenuView()
        hideMenuOption()
    }
    
//    @objc func date(_ sender: UIDatePicker){
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "MMM dd yyyy"
////        self.ageLabel.text = dateformatter.string(from: sender.date)
//    }
//
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
        locationNameLabel.delegate = self
        self.picker.delegate = self
        self.picker.backgroundColor = UIColor.white
        initPinterestLayout()
        
        heightTextField.delegate = feetInchDelegate
    }
    
//    func showdatePicker(){
//        self.datePicker.datePickerMode = .date
//        datePicker.maximumDate = Date()
//        datePicker.backgroundColor = UIColor.white
////        self.ageLabel.inputView = self.datePicker
//        datePicker.addTarget(self, action: #selector(date), for: .valueChanged)
//    }
    
    func loadData(){
        self.nameTextField.text = self.model.userName ?? ""
        self.ageLabel.text = "\(self.model.DateOfBirth ?? 0)"
        ageSlider.value = Float(self.model.DateOfBirth ?? 0)
        self.userImageView.sd_setImage(with: URL(string: self.model.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"), options: .refreshCached, progress: nil) { (image, error, cache, url) in
            if image != nil{
                self.userImageView.image = image
            }
            else{
                self.userImageView.image = #imageLiteral(resourceName: "profilePlaceholder")
            }
        }
//        self.videoImage.sd_setImage(with: URL(string: self.model.videoImage ?? ""), placeholderImage: #imageLiteral(resourceName: "crop"), options: .refreshCached) { (image, error, cache, url) in
//            if image != nil{
//                self.videoImage.image = image
//            }else{
//                self.videoImage.image = #imageLiteral(resourceName: "crop")
//            }
//        }
        self.heightTextField.text = self.model.height ?? ""
        self.longestRelationshipLabel.text = self.model.longestRelationship ?? ""
        self.kidLabel.text = self.model.kids ?? ""
        self.descriptionTextView.text = ((self.model.Aboutme ?? "") != "") ? (self.model.Aboutme ?? "") : ""
        self.bodyTypeLabel.text = self.model.bodyType ?? ""
        self.locationNameLabel.text = self.model.address ?? ""
    }
    func getImages(){
        let param : Parameters = ["user_id": standard.string(forKey: "userId") ?? ""]
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "getImages", param: param, header: [:], success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                self.images = json["res"].arrayValue
                self.collectionView.reloadData()
            }else{
                self.showalert(msg: json["message"].stringValue)
            }
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    func saveImage(image:UIImage){
        let param : Parameters = ["userID": standard.string(forKey: "userId") ?? ""]
        ApiInteraction.sharedInstance.funcToHitMultipartApi(url: apiURL + "saveImage", param: param, header: [:], imageArray: [image], imageName: ["image.jpg"], success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                self.images = json["res"].arrayValue
                self.collectionView.reloadData()
            }else{
                self.showalert(msg: json["message"].stringValue)
            }
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    @IBAction func onAgeChanged(_ sender: UISlider) {
        print(sender.value)
        ageLabel.text = "\(Int(sender.value))"
    }
    //MARK:- Actions
    @IBAction func saveAction(_ sender: Any) {
//        guard (self.jobLabel.text ?? "") != "" else{
//            self.showalert(msg: "Please Enter BodyType")
//            return
//        }
//        showVideo = false
        self.saveApi()
    }
    
    @IBAction func onBack(_ sender: Any) {
    }
    @IBAction func recordButtonAction(_ sender: Any) {
        self.selectedMediaType = 1
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
        self.selectedMediaType = 0
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
    
    func uploadImageAction() {
        self.selectedMediaType = 2
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
            "UserName": nameTextField.text ?? "",
            "OnlineStatus": "1",
            "Address": self.locationNameLabel.text ?? "",
            "AboutMe": self.descriptionTextView.text ?? "",
            "BodyType" : bodyTypeLabel.text ?? "",
            "DOB": ageLabel.text ?? "",
            "UserAge": ageLabel.text ?? "",
            //                                 "LookingFor" : lookingForTextfield.text ?? "",
            "LongestRelationship": longestRelationshipLabel.text ?? "",
            "Kids": kidLabel.text ?? "",
            "Hobbies": hobbiesTextView.text ?? "",
            "height": heightTextField.text ?? "",
            
//                                 "VedioUrl" : self.videoURL ?? "",
            "latitude" : "\(lat ?? 0.0)",
            "longitude" : "\(long ?? 0.0)"
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitMultipartApi(url: apiURL + "updateuserProfile", param: param, header: [:], imageArray: [self.userImageView.image ?? UIImage()], imageName: ["profilePic"], success: { (json) in
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
    func uploadImage(image:UIImage){
        self.view.startProgressHub()
        let param: Parameters = [
        "user_id": standard.string(forKey: "userId") ?? "" ]
        ApiInteraction.sharedInstance.funcToHitMultipartApi(url: apiURL + "uploadImage", param: param, header: [:], imageArray: [image], imageName: ["profilePic"], success: { (json) in
            print(json)
             self.view.stopProgresshub()
            if json["status"].intValue == 1{
                self.getImages()
            }else{
                self.showalert(msg: json["message"].stringValue)
            }
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    func deleteImage(id:String){
        self.view.startProgressHub()
        let param: Parameters = ["image_id": id]
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "deleteImage", param: param, header: [:]) { json in
            print(json)
             self.view.stopProgresshub()
            if json["status"].intValue == 1{
                self.getImages()
            }else{
                self.showalert(msg: json["message"].stringValue)
            }
        } failure: { error in
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
        /* if textField == lookingForTextfield{
            isType = "looking"
            textField.text = self.lookingArray[0]
        }
        else if textField == kidsTxtField{
            isType = "kid"
            textField.text = self.kidArray[0]
        }else */if textField == locationNameLabel{
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if hobbiesTextView == textView {
            
        }
    }
    @IBAction func onLongestRelationshipClicked(_ sender: Any) {
        isType = "relationship"
        longestRelationshipLabel.text = self.relationArray[0]
        self.picker.reloadAllComponents()
        self.picker.reloadInputViews()
        showPicker()
    }
    func showPicker(){
//        picker = UIPickerView.init()
//        picker.delegate = self
//        picker.backgroundColor = UIColor.white
//        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    @IBAction func onKidSelected(_ sender: Any) {
        isType = "kid"
        longestRelationshipLabel.text = self.relationArray[0]
        self.picker.reloadAllComponents()
        self.picker.reloadInputViews()
        showPicker()
    }
    @IBAction func onBodySelected(_ sender: Any) {
        isType = "body"
        longestRelationshipLabel.text = self.relationArray[0]
        self.picker.reloadAllComponents()
        self.picker.reloadInputViews()
        showPicker()
    }
    //MARK:- ImagePickerDelegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let filePath = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            if selectedMediaType == 0 {
                self.userImageView.image = filePath
            }
            else {
                self.uploadImage(image: filePath)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - textViewDelegates
    func textViewDidChange(_ textView: UITextView) {
//        if textView.contentSize.height >= 100{
//            self.descriptionHeight.constant = 100
//            textView.isScrollEnabled = true
//        }else if textView.contentSize.height > 65 &&  textView.contentSize.height < 100{
//            self.descriptionHeight.constant = textView.contentSize.height
//            textView.isScrollEnabled = true
//        }else if textView.contentSize.height <= 65{
//            self.descriptionHeight.constant = 65
//        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text == ""{
//            textView.text = "Write Descriptions..."
//            descriptionTextView.textColor = UIColor.lightGray
//        }
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
       if isType == "body"{
            return bodyArray.count
        }else if isType == "looking"{
            return lookingArray.count
        }else if isType == "kid"{
            return kidArray.count
        }else if isType == "relationship"{
            return relationArray.count
       }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isType == "body"{
            return bodyArray[row]
        }else if isType == "looking"{
            return lookingArray[row]
        }else if isType == "kid"{
            if kidArray.count > row {
                return kidArray[row]
            }
            else {
                return kidArray[kidArray.count - 1]
            }
        }else if isType == "relationship"{
            return relationArray[row]
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isType == "body"{
            bodyTypeLabel.text = bodyArray[row]
        }else if isType == "looking"{
//            lookingForTextfield.text = lookingArray[row]
        }else if isType == "kid"{
            if kidArray.count > row {
                kidLabel.text = kidArray[row]
            }
            else {
                kidLabel.text = kidArray[kidArray.count - 1]
            }
        }else if isType == "relationship"{
            longestRelationshipLabel.text = relationArray[row]
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
extension EditProfileViewController: PinterestLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == images.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
        let imageView = cell.viewWithTag(100) as! UIImageView
        let imageUrl = "\(imageURL)\(images[indexPath.row]["image"].stringValue)"
        print(imageUrl)
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "anonymous.jpg"))
        return cell
    }
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        var height:CGFloat = 0
        switch indexPath.row % 5 {
        case 0:
            height = 100
        case 1:
            height = 160
        case 2:
            height = 100
        case 3:
            height = 160
        case 4:
            height = 100
        default:
            break
        }
        return height
    }
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        let textFont = UIFont(name: "Arial-ItalicMT", size: 11)!
        return "Some text".heightForWidth(width: withWidth, font: textFont)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == images.count {
            self.selectedMediaType = 2
            self.uploadImageAction()
//            let introSilder = storyboard!.instantiateViewController(withIdentifier: "upload_video")
//            introSilder.modalPresentationStyle = .fullScreen
//            present(introSilder, animated: false, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Do you want remove this image?", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Delete it", style: .default) { [self] (alert) in
                self.deleteImage(id: self.images[indexPath.row]["id"].stringValue)
            }
            let cancelAction = UIAlertAction(title: "No, I will keep it.", style: .default, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
extension EditProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var newHeight:Float = 400
        newHeight = newHeight - Float(scrollView.contentOffset.y)
        if( newHeight < 150) {
            newHeight = 150
        }
        userImageHeightConstraint.constant = CGFloat(newHeight)
    }
}
