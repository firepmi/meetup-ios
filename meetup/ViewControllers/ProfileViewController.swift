//
//  ProfileViewController.swift
//  meetup
//
//  Created by An Phan on 3/23/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import AVKit
import MobileCoreServices
import SDWebImage

class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lookingForLabel: UILabel!
    @IBOutlet weak var longestRelationshipLabel: UILabel!
    @IBOutlet weak var kidsLabel: UILabel!
    @IBOutlet weak var hobbiesLabel: UILabel!
    @IBOutlet weak var percentLikeLabel: UILabel!
    @IBOutlet weak var percentPassLabel: UILabel!
    @IBOutlet weak var percentHeartLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var instagramNameLabel: UILabel!
    @IBOutlet weak var facebookNameLabel: UILabel!
    @IBOutlet weak var googlePlusNameLabel: UILabel!
    @IBOutlet weak var youtubeNameLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var contentTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var roundedView: RoundedView!
    
    
    // MARK: - Variables
    var spacingOfScrollView: CGFloat = 15
    var model = ProfileModel.init(json: JSON(JSON.self))
    var userId: String?
    
    // MARK: - Private var/let
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Look Listen & Feel"
        // Handle side menu
        self.sideMenuController()?.sideMenu?.delegate = self
        // Set gradient of navigationBar
        gradientOfNavigationBar()
        addTapGeture()
        addSwipeGeture()
        prepareNavigationBar()
        fetchUserProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden  = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideSideMenuView()
    }
    
    // MARK: - Objc Methods
    @objc func moreBarButtonAction() {
        toggleSideMenuView()
    }
    
    @objc func mainViewTapped() {
        hideSideMenuView()
        hideMenuOption()
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
    
    
    
    //MARK:- Other functions
    func loadData(){
        self.userNameLabel.text = self.model.userName ?? ""
        self.ageLabel.text = self.dateConverter(string: "\(self.model.DateOfBirth ?? "")")
        self.userImageView.sd_setImage(with: URL(string: (self.model.userImage ?? "")), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"), options: .refreshCached) { (image, error, cache, url) in
            if image != nil{
                self.userImageView.image = image
            }else{
                self.userImageView.image = #imageLiteral(resourceName: "profilePlaceholder")
            }
        }
        self.lookingForLabel.text = self.model.lookingFor ?? ""
        self.longestRelationshipLabel.text = self.model.longestRelationship ?? ""
        self.kidsLabel.text = self.model.kids ?? ""
        self.descriptionLabel.text = (self.model.Aboutme ?? "")
        self.percentLikeLabel.text = (self.model.likePercentage ?? "0") + "% Like"
        self.percentPassLabel.text = (self.model.unlikePercentage ?? "0") + "% Pass"
        self.percentHeartLabel.text = (self.model.favouritePercentage ?? "0")
        self.jobLabel.text = self.model.bodyType ?? ""
        self.locationNameLabel.text = self.model.address ?? ""
        self.videoImage.sd_setImage(with: URL(string: self.model.videoImage ?? ""), placeholderImage: #imageLiteral(resourceName: "crop"), options: .refreshCached) { (image, error, cache, url) in
            if image != nil{
                self.videoImage.image = image
            }else{
                self.videoImage.image = #imageLiteral(resourceName: "crop")
            }
        }
        self.instagramNameLabel.text = self.model.instagramUrl ?? ""
        self.facebookNameLabel.text = self.model.facebookUrl ?? ""
        self.googlePlusNameLabel.text = self.model.googleplusUrl ?? ""
        self.youtubeNameLabel.text = self.model.youtubeUrl ?? ""
        self.roundedView.isHidden = ((self.model.onlineStatus ?? "") == "0")
    }
    
    
    
    // MARK: - IBActions
    @IBAction func likeButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func unlikeButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func heartButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func recordButtonAction(_ sender: UIButton) {
        if String(self.model.vedioUrl!.prefix(4)) != "http" {
            self.model.vedioUrl = baseURL + "img/user_profile_pics/" + self.model.vedioUrl!
        }
        
        if let url = URL(string: self.model.vedioUrl ?? ""){
            let player = AVPlayer(url: url)
            
            let playerController = AVPlayerViewController()
            
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
            }
        }
    }
    
    @IBAction func openInsta(_ sender: Any) {
        guard ((self.instagramNameLabel.text ?? "") != "")else{
            return
        }
        AppState.openURL(app: "Instagram", userName: self.instagramNameLabel.text ?? "")
    }
    
    @IBAction func openFacebook(_ sender: Any) {
        guard ((self.facebookNameLabel.text ?? "") != "")else{
            return
        }
        AppState.openURL(app: "Facebook", userName: self.facebookNameLabel.text ?? "")
    }
    
    @IBAction func openGooglePlus(_ sender: Any) {
        guard ((self.googlePlusNameLabel.text ?? "") != "")else{
            return
        }
        AppState.openURL(app: "Googleplus", userName: self.googlePlusNameLabel.text ?? "")
    }
    
    @IBAction func openYouTube(_ sender: Any) {
        guard ((self.youtubeNameLabel.text ?? "") != "")else{
            return
        }
        AppState.openURL(app: "Youtube", userName: self.youtubeNameLabel.text ?? "")
    }
    
    @IBAction func messageAction(_ sender: Any) {
      
        let chatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.otherUserName = self.model.userName ?? ""
        chatVC.otherUserImage = self.model.userImage ?? ""
        chatVC.otherUserId = self.userId ?? ""
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func commentAction(_ sender: Any) {
        guard standard.bool(forKey: "paymentStatus")else{
            self.showalert(msg: "Please upgrade application First")
            return
        }
        let commentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        commentVC.receiverId = self.userId ?? ""
//        commentVC.blockStatus = true
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    
    
    //MARK:- Api's
    ///function to fetchUserProfile
    func fetchUserProfile(){
        let param : Parameters = ["userID": userId ?? ""]
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
}

// MARK: - ENSideMenuDelegate -
extension ProfileViewController: ENSideMenuDelegate {
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
