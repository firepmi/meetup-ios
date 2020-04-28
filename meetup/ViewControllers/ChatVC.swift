//
//  ChatVC.swift
//  Football
//
//  Created by Mohit Gupta on 06/07/18.
//  Copyright © 2018 i Next Solutions. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
import Photos
import Firebase
import FirebaseDatabase
import SDWebImage
import IQKeyboardManager

//MARK: - InboxCell Class -
class InboxCell: UITableViewCell {
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var playButton1: UIButton!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
}

//MARK: - InboxCell2 Class -
class InboxCell2: UITableViewCell {
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var profileImg2: UIImageView!
    @IBOutlet weak var playButton2: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
}

//MARK: - ChatViewController -
class ChatVC: UIViewController,UITextFieldDelegate ,UIGestureRecognizerDelegate{
    
    //MARK: - Outlets
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var inboxTableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var titileLbl: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var sendButt: UIButton!
    @IBOutlet weak var messageTxt: UITextView!
    @IBOutlet weak var profileImg: UIImageView!
    
    //MARK: - Variables
    var imagePickerController = UIImagePickerController()
    var messageArr = NSMutableArray()
    var imageUrl : String?
    var videoUrl : String?
    var getImageData : NSDictionary?
    var videoExt = NSString()
    var usernames = [String]()
    var otherUserId : String?
    var otherUserName : String?
    var otherUserImage : String?
    var otherId :String?
    var selectIndex = NSInteger()
    var getImage :UIImage?
    var dictChat = Dictionary<String, Array<Message>>()
    var sortedSections = [String]()
    var tableSection = [Message]()
    var dateFormatter = DateFormatter()
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        // messageTxt.delegate = self
       
//        automaticallyAdjustsScrollViewInsets = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
        self.inboxTableView.delegate = self
        self.inboxTableView.dataSource = self
        self.profileImg.sd_setHighlightedImage(with: URL(string: standard.string(forKey: "userImage") ?? ""), options: SDWebImageOptions.refreshCached) { (image, error, Cache, url) in
            if image != nil{
                self.profileImg.image = image
            }else{
                self.profileImg.image = #imageLiteral(resourceName: "profilePlaceholder")
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.getChat()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - @Objc Methods
    @objc func hideKeyboard(sender: UITapGestureRecognizer? = nil) {
        //handling code
        self.view.endEditing(true)
        messageTxt.resignFirstResponder()
    }
    
    
    //MARK: - IBActions
    @IBAction func camerButtonAction(_ sender: Any) {
        var alert = UIAlertController(title: "Select Option", message: "", preferredStyle: .actionSheet)
        if !UIDevice.isPhone {            //In iPad Change Rect to position Popover
            alert = UIAlertController(title: "Select Option", message: "", preferredStyle: .alert)
        }
        for i in ["Select Photo", "Take Photo"] {
            alert.addAction(UIAlertAction(title: i, style: UIAlertAction.Style.default, handler: actionHandle))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: actionHandle))
        if !UIDevice.isPhone {            //In iPad Change Rect to position Popover
            
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        if self.messageTxt.text != "" {
            sendTextMessage()
            self.messageTxt.resignFirstResponder()
        }
        else{
            //  sendMediaMessage()
        }
    }
    
    
    //MARK: - Addtional Functions
    func getChat() {
        dateFormatter.dateFormat = "dd-MM-YYYY"
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Chats").child("MeetUp_" + standard.string(forKey: "userId")!).child("MeetUp_" + (otherUserId ?? "")).observe(.value) { (snapshot) in
            self.dictChat.removeAll()
            self.sortedSections.removeAll()
            if snapshot.childrenCount > 0 {
                for message in snapshot.children.allObjects as! [DataSnapshot] {
                    let messageObject = message.value as? [String: AnyObject]
                    let chatMessage = Message.init()
                    chatMessage.messageType = messageObject?["messageType"] as? String
                    chatMessage.text = messageObject?["text"] as? String
                    chatMessage.userImage = messageObject?["userImage"] as? String
                    chatMessage.userName = messageObject?["senderName"] as? String
                    chatMessage.time = messageObject?["time"] as! Int64
                    chatMessage.userId = messageObject?["senderId"] as? String
                    chatMessage.imageLink = messageObject?["attachmentImage"] as? String
                    let dateStr = self.getStringFromInterval(interval: chatMessage.time)
                    if self.dictChat.index(forKey: dateStr) == nil {
                        self.dictChat[dateStr] = [chatMessage]
                        self.sortedSections.append(dateStr)
                    }
                    else {
                        self.dictChat[dateStr]!.append(chatMessage)
                    }
                }
                _ =    self.sortedSections.sorted(by: { self.dateFormatter.date(from:$0)?.compare(self.dateFormatter.date(from:$1)!) == .orderedDescending })
                
                print(self.dictChat)
                self.inboxTableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.tableSection.count>0{
                let numberOfSections = self.inboxTableView.numberOfSections
                let numberOfRows = self.inboxTableView.numberOfRows(inSection: numberOfSections-1)
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.inboxTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    func sendMediaMessage() {
        let time = self.getTime()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        _ = self.messageTxt.text
        let message :[String:Any] = ["text": "[attachment]",
                                     "messageType":"1",
                                     "senderImage":standard.string(forKey: "userImage") ?? "",
                                     "senderName":standard.string(forKey: "userName") ?? "",
                                     "time": time,
                                     "attachmentImage":self.convertImageToBase64(image: self.getImage!),
                                     "senderId":standard.string(forKey: "userId") ?? "",
                                     "receiverId": otherUserId ?? ""]
        
        
        self.messageTxt.text = nil
        let lastMessageSender :[String:Any] = ["text" : "[attachment]",
                                               "time" : time,
                                               "userName": otherUserName ?? "",
                                               "userId" : otherUserId ?? "",
                                               "userProfilePic" : otherUserImage ?? ""]
        
        let lastMessageReceiver :[String:Any] = ["text" : "[attachment]",
                                                 "time" : time,
                                                 "userName": standard.string(forKey: "userName") ?? "",
                                                 "userId" :standard.string(forKey: "userId") ?? "",
                                                 "userProfilePic" : standard.string(forKey: "userImage") ?? ""]
        ref.child("Chats").child("MeetUp_" + standard.string(forKey: "userId")!).child("MeetUp_" + otherUserId!).childByAutoId().updateChildValues(message)
        ref.child("Chats").child("MeetUp_" + otherUserId!).child("MeetUp_" + standard.string(forKey: "userId")!).childByAutoId().updateChildValues(message)
        ref.child("ChatWindow").child("MeetUp_" + otherUserId!).child("MeetUp_" + standard.string(forKey: "userId")!).updateChildValues(lastMessageReceiver)
        ref.child("ChatWindow").child("MeetUp_" + standard.string(forKey: "userId")!).child("MeetUp_" + otherUserId!).updateChildValues(lastMessageSender)
    }
    func sendTextMessage() {
        let time = self.getTime()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let textMessage = self.messageTxt.text
        let message :[String:Any] = ["text": textMessage ?? "",
                                     "messageType":"0",
                                     "senderImage":standard.string(forKey: "userImage") ?? "",
                                     "senderName":standard.string(forKey: "userName") ?? "",
                                     "time": time,
                                     "senderId":standard.string(forKey: "userId") ?? "",
                                     "receiverId": otherUserId ?? ""]
        
        
        self.messageTxt.text = nil
        let lastMessageSender :[String:Any] = ["text" : textMessage ?? "",
                                               "time" : time,
                                               "userName": otherUserName ?? "",
                                               "userId" : otherUserId ?? "",
                                               "userProfilePic" : otherUserImage ?? ""]
        
        let lastMessageReceiver :[String:Any] = ["text" : textMessage ?? "",
                                                 "time" : time,
                                                 "userName": standard.string(forKey: "userName") ?? "",
                                                 "userId" : standard.string(forKey: "userId") ?? "",
                                                 "userProfilePic" :standard.string(forKey: "userImage") ?? ""]
        ref.child("Chats").child("MeetUp_" + standard.string(forKey: "userId")!).child("MeetUp_" + otherUserId!).childByAutoId().updateChildValues(message)
        ref.child("Chats").child("MeetUp_" + otherUserId!).child("MeetUp_" + standard.string(forKey: "userId")!).childByAutoId().updateChildValues(message)
        ref.child("ChatWindow").child("MeetUp_" + otherUserId!).child("MeetUp_" + standard.string(forKey: "userId")!).updateChildValues(lastMessageReceiver)
        ref.child("ChatWindow").child("MeetUp_" + standard.string(forKey: "userId")!).child("MeetUp_" + otherUserId!).updateChildValues(lastMessageSender)
        
        
    }
    func actionHandle(action: UIAlertAction) {
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
        //        imagePickerController.delegate = self
        //        imagePickerController.allowsEditing = true
        //        if action.title == "Select Photo" {
        //            imagePickerController.sourceType = .savedPhotosAlbum
        //            imagePickerController.mediaTypes = [kUTTypeImage as String]
        //            self.navigationController?.present(imagePickerController, animated: true, completion: nil)
        //        } else if action.title == "Take Photo" {
        //            imagePickerController.sourceType = .camera
        //            imagePickerController.mediaTypes = [kUTTypeImage as String]
        //            imagePickerController.videoMaximumDuration = 30.0
        //            self.navigationController?.present(imagePickerController, animated: true, completion: nil)
        //        }
        //        else if action.title == "Select Video" {
        //            imagePickerController.sourceType = .savedPhotosAlbum
        //            imagePickerController.mediaTypes = [kUTTypeMovie as String]
        //            self.navigationController?.present(imagePickerController, animated: true, completion: nil)
        //        } else if action.title == "Record Video" {
        //            imagePickerController.sourceType = .camera
        //            imagePickerController.mediaTypes = [kUTTypeMovie as String]
        //            imagePickerController.videoMaximumDuration = 30.0
        //            self.navigationController?.present(imagePickerController, animated: true, completion: nil)
        //        }
    }
    func checkForCameraAccess() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            // permission dialog not yet presented, request authorization
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                          completionHandler: { (granted:Bool) -> Void in
                                            if granted {
                                                print("access granted")
                                                self.imagePickerController.sourceType    = UIImagePickerController.SourceType.camera
                                                self.imagePickerController.allowsEditing = true
                                                DispatchQueue.main.async {
                                                    self.present(self.imagePickerController, animated: true, completion: nil)
                                                }
                                            }
                                            else {
                                                print("access denied")
                                                //self.presentNoMediaPermissionPage()
                                            }
            })
        case .authorized:
            print("Access authorized")
            self.imagePickerController.sourceType    = UIImagePickerController.SourceType.camera
            self.imagePickerController.allowsEditing = true
            DispatchQueue.main.async {
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        case .denied, .restricted:
            print("Denied Restricted")
        }
    }
    
    func checkForPhotosAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // handle authorized status
            print("Authorized")
            self.imagePickerController.sourceType    = UIImagePickerController.SourceType.photoLibrary
            self.imagePickerController.allowsEditing = true
            DispatchQueue.main.async {
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        case .denied, .restricted :
            // handle denied status
            print("Denied, Restricted")
            //self.presentNoMediaPermissionPage()
            break
        case .notDetermined:
            // ask for permissions
            print("NotDetermined")
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                switch status {
                case .authorized:
                    // as above
                    self.imagePickerController.sourceType    = UIImagePickerController.SourceType.photoLibrary
                    self.imagePickerController.allowsEditing = true
                    DispatchQueue.main.async {
                        self.present(self.imagePickerController, animated: true, completion: nil)
                    }
                case .denied, .restricted:
                    // as above
                    //                    self.presentNoMediaPermissionPage()
                    break
                case .notDetermined:
                    // won't happen but still
                    break
                }
            }
        }
    }
}
// MARK: TableView Delegate and Datasource Method -
extension ChatVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bounds = UIScreen.main.bounds
        let screenWidth = bounds.size.width
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:25))
        let label = UILabel(frame: CGRect(x:(screenWidth/2)-50,y:0, width:90, height:25))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.text = sortedSections[section]
        label.backgroundColor = .darkGray
        view.addSubview(label);
        
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dictChat.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dictChat[sortedSections[section]]!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableSection = dictChat[sortedSections[indexPath.section]]!
        let message = tableSection[indexPath.row]
        let messageType = message.messageType
        let attchemnetImg = message.imageLink
        if message.userId == standard.string(forKey: "userId") {
            if messageType == "1"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCellImage2", for: indexPath) as! InboxCell2
                cell.messageImage.image = self.convertBase64ToImage(imageString: attchemnetImg ?? "")
                let timeStamp = message.time
                cell.dateLabel.text = self.getTimeFromTimeInterval(interval: timeStamp)
                self.selectIndex = indexPath.section
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell2", for: indexPath) as! InboxCell2
                
                cell.messageView.layer.cornerRadius = 5.0
                cell.messageView.layer.masksToBounds = true
                cell.messageLabel?.text = message.text
                let timeStamp = message.time
                cell.dateLabel.text = self.getTimeFromTimeInterval(interval: timeStamp)
                
                return cell
            }
        }
        else{
            if messageType == "1"{
                
                let  cell = tableView.dequeueReusableCell(withIdentifier: "InboxCellImage", for: indexPath) as! InboxCell
                cell.messageImage.image = self.convertBase64ToImage(imageString: attchemnetImg ?? "")
                let timeStamp = message.time
                cell.dateLabel.text = self.getTimeFromTimeInterval(interval: timeStamp)
                cell.profileImg.layer.cornerRadius = cell.profileImg.frame.width / 2
                cell.profileImg.layer.masksToBounds = true
                
                cell.profileImg.sd_setHighlightedImage(with: URL(string: message.userImage ?? ""), options: SDWebImageOptions.refreshCached) { (image, error, Cache, url) in
                    if image != nil{
                        cell.profileImg.image = image
                    }else{
                        cell.profileImg.image = #imageLiteral(resourceName: "profilePlaceholder")
                    }
                }
                self.selectIndex = indexPath.section
                cell.userNameLbl.text = message.userName?.lowercased()
                
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell", for: indexPath) as! InboxCell
                let timeStamp = message.time
                cell.messageLabel?.text = message.text
                cell.messageView.layer.cornerRadius = 5.0
                cell.messageView.layer.masksToBounds = true
                cell.dateLabel.text = self.getTimeFromTimeInterval(interval: timeStamp)
                cell.profileImg.layer.cornerRadius = cell.profileImg.frame.width / 2
                cell.profileImg.layer.masksToBounds = true
                cell.profileImg.sd_setHighlightedImage(with: URL(string: otherUserImage ?? ""), options: SDWebImageOptions.refreshCached) { (image, error, Cache, url) in
                    if image != nil{
                        cell.profileImg.image = image
                    }else{
                        cell.profileImg.image = #imageLiteral(resourceName: "profilePlaceholder")
                    }
                }
                
                cell.userNameLbl.text = message.userName?.lowercased()
                
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if dictChat.count>0{
            let tableSection = dictChat[sortedSections[indexPath.section]]
            let message = tableSection![indexPath.row]
            let messageType = message.messageType
            if messageType == "2"{
            }
        }
    }
    func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
}
//MARK:- ImagePicker Delegate -
extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        self.navigationController?.dismiss(animated: true) {
    //
    //            if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
    //                if mediaType == (kUTTypeImage as String) {
    //                    //var url = ""
    //                    if #available(iOS 11.0, *) {
    //                        if let URL =  info[UIImagePickerController.InfoKey.imageURL] {
    //                            _ = (URL as AnyObject).absoluteString!!
    //                        }
    //                    }
    //                    self.getImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
    ////                  self.imageUpload(image: image)
    //                    self.sendMediaMessage()
    //
    ////                } else if mediaType == (kUTTypeMovie as String) {
    ////                    print("Video Selected")
    ////                    let videoURL = info[UIImagePickerController.InfoKey.mediaURLUIImagePickerController.InfoKey.mediaURL] as? NSURL
    ////                    self.videoExt = (videoURL?.pathExtension as NSString?)!
    ////                    do {
    ////                        let asset = AVURLAsset(url: videoURL! as URL , options: nil)
    ////                        let imgGenerator = AVAssetImageGenerator(asset: asset)
    ////                        imgGenerator.appliesPreferredTrackTransform = true
    ////                        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
    ////                        let thumbnail = UIImage(cgImage: cgImage)
    ////                        let videoFileURL = videoURL?.filePathURL
    ////                        let videoData = try NSData(contentsOf: videoFileURL!, options: .mappedIfSafe)
    ////                        //self.videoChatPost(thumbnailImage: thumbnail, videoData:videoData as Data )
    ////                     } catch let error {
    ////                        print("*** Error generating thumbnail: \(error.localizedDescription)")
    ////                    }
    //                }
    //            }
    //        }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.getImage = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
        self.sendMediaMessage()
        dismiss(animated: true, completion: nil)
    }
    
    
    func convertImageToBase64(image: UIImage) -> String {
        
        let imageData = image.pngData()
        return imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
    }
    func playVideo(url: String) {
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
