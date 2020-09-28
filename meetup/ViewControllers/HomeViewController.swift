//
//  HomeViewController.swift
//  meetup
//
//  Created by An Phan on 3/21/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire
import SwiftyJSON
import VerticalCardSwiper
import SDWebImage
class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var unlikeImageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var reloadImageView: UIImageView!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet private var cardSwiper: VerticalCardSwiper!
    @IBOutlet weak var onlineStatus: UILabel!
    @IBOutlet weak var tutorialView: UIView!
    
    
    // MARK: - Variables
    var index : Int?
    var model = [AllProfileModel]()
    var cardView : VerticalCardSwiper!
    var showDistance : Bool?
    
    // MARK: - Private var/let
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       cardView = VerticalCardSwiper(frame: self.cardSwiper.frame)
        
        SubscriptionProducts.store.requestProducts({ [weak self] success, products in
            guard self != nil else { return }
            if success {
                print("Products count: \(products!.count)")
                let isPro = SubscriptionProducts.store.isProductPurchased(SubscriptionProducts.subscriptionID)
                standard.set(isPro, forKey: "paymentStatus")
                print(SubscriptionProducts.subscriptionID, isPro)                
            }
        })
        if standard.bool(forKey: "tutorial") {
            tutorialView.isHidden = true
        }
        else {
            showIntroSlide()
            tutorialView.isHidden = false
        }
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func showIntroSlide() {
        let introSilder = storyboard!.instantiateViewController(withIdentifier: "intro_slide")
        introSilder.modalPresentationStyle = .fullScreen
        present(introSilder, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide back button
        navigationItem.hidesBackButton = true
        navigationController?.isToolbarHidden  = true
        // Side menu delegate
        self.sideMenuController()?.sideMenu?.delegate = self
       navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Connection"//"Look Listen & Feel"
        // Show navigation bar
        navigationController?.isNavigationBarHidden = false
        self.sideMenuController()?.sideMenu?.delegate = self
        // Prepare collectionView
        
        
        cardView.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
        //        cardView.bounds = self.cardSwiper.bounds
        cardView.frame = CGRect(x: 15, y: 20, width: self.view.frame.width - 30, height: self.cardSwiper.frame.height)  //self.view.frame.height - self.viewBottomheight.constant - 95
        cardSwiper.addSubview(cardView)
        cardSwiper.backgroundColor = UIColor.clear
        cardView.delegate = self
        cardView.datasource = self
        cardView.isPreviousCardVisible = false
        cardView.visibleNextCardHeight = 0
        cardView.isSideSwipingEnabled = false
        cardView.register(nib: UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeViewCell")
        prepareGradient()
        addTapGeture()
        addSwipeGeture()
        DispatchQueue.main.async {
            if self.model.count != 0{
                self.loadData()
                
            }else{
                if !(self.sideMenuController()?.sideMenu?.isMenuOpen ?? false){
                    DispatchQueue.main.async {
                        self.fetchAllProfile()
                    }
                }else{
                    self.fetchAllProfile()
                    self.hideSideMenuView()
                }
            }
        }
    }
    
    @IBAction func closeTutorial(_ sender: Any) {
        tutorialView.isHidden = true
        standard.set(true, forKey: "tutorial")
    }
    
    // MARK: - @Objc Methods
    @objc func mainViewTapped(swipe: UISwipeGestureRecognizer) {
        hideSideMenuView()
        disableUIView(isEnable: true)
        hideMenuOption()
    }
    
    // MARK: - Private methods
    private func addTapGeture() {
        tapGeture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        tapGeture.isEnabled = false
        view.addGestureRecognizer(tapGeture)
    }
    
    private func addSwipeGeture() {
        swipeGeture = UISwipeGestureRecognizer(target: self, action: #selector(mainViewTapped))
        swipeGeture.isEnabled = false
        swipeGeture.direction = .right
        view.addGestureRecognizer(swipeGeture)
    }
    
    private func hideMenuOption() {
//        collectionViewTrailingConstraint.constant = spacingOfCollectionView
//        collectionViewLeadingConstraint.constant = spacingOfCollectionView
        UIView.animate(withDuration: 0.4) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    private func disableUIView(isEnable: Bool) {
//        collectionView.isUserInteractionEnabled = isEnable
        reloadButton.isUserInteractionEnabled = isEnable
        flagButton.isUserInteractionEnabled = isEnable
        heartButton.isUserInteractionEnabled = isEnable
    }
    
    private func prepareGradient() {
        // Set gradient of mainView
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let color = UIColor(hexString: "ffffff")//e51f41
        let color1 = UIColor(hexString: "ffffff")//ff7761
        gradientLayer.colors = [color1.cgColor, color.cgColor]
        self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
        // Set gradient of navigationBar
        gradientOfNavigationBar()
    }
    
    private func clickButtonAnimation(_ animation: (() -> Void)?) {
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6,
                       options: .allowUserInteraction,
                       animations: {
           animation?()
        }, completion: nil)
    }
    private func playVideo(fileURL: String) {
        var videoUrl = fileURL

        if String(videoUrl.prefix(4)) != "http" {
            videoUrl = imageURL + videoUrl
        }
     
        if let url = URL(string: videoUrl){
            let player = AVPlayer(url: url)
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
            }
        }else{
            self.showalert(msg: "No Video Available")
        }
    }
    
    private func videoPreviewUiimage(fileurl: String) -> UIImage? {
        if let url = URL(string: fileurl) {
            
            let asset = AVURLAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let timestamp = CMTime(seconds: 1, preferredTimescale: 6)
            do {
                let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
                return UIImage(cgImage: imageRef)
            }
            catch let error as NSError
            {
                print("Image generation failed with error \(error)")
                     return  #imageLiteral(resourceName: "crop")
            }
        }
        return nil
    }
    
    // MARK: - IBActions
    @IBAction func likeButtonAction(_ sender: UIButton) {
        self.likeImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        clickButtonAnimation {
            self.likeImageView.transform = .identity
            self.likeImageView.image = (self.likeImageView.image == #imageLiteral(resourceName: "like-icon")) ? #imageLiteral(resourceName: "like-small") : #imageLiteral(resourceName: "like-icon")
            self.unlikeImageView.image = #imageLiteral(resourceName: "unlike-icon")
            
        }
       
         self.statusApi(status: "1")
    }
    
    @IBAction func unlikeButtonAction(_ sender: UIButton) {
        self.unlikeImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        clickButtonAnimation {
            self.unlikeImageView.transform = .identity
            self.unlikeImageView.image = (self.unlikeImageView.image == #imageLiteral(resourceName: "unlike-icon")) ? #imageLiteral(resourceName: "unlike-small") : #imageLiteral(resourceName: "unlike-icon")
            self.likeImageView.image = #imageLiteral(resourceName: "like-icon")
        }
            self.statusApi(status: "2")
        
    }
    
    @IBAction func heartButtonAction(_ sender: UIButton) {
        self.heartImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        clickButtonAnimation {
            self.heartImageView.transform = .identity
            self.heartImageView.image = (self.heartImageView.image == #imageLiteral(resourceName: "heart-small")) ? #imageLiteral(resourceName: "heart-icon") : #imageLiteral(resourceName: "heart-small")
        }
            self.statusApi(status: "3")
        
    }
    
    @IBAction func flagButtonAction(_ sender: UIButton) {
        self.flagImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        if self.flagImageView.image == #imageLiteral(resourceName: "flag-icon"){
//            let okAction = UIAlertAction(title: "Report", style: .default) { (alert) in
//                self.clickButtonAnimation {
//                    self.flagImageView.transform = .identity
//                    self.flagImageView.image = (self.flagImageView.image == #imageLiteral(resourceName: "flag-icon")) ? #imageLiteral(resourceName: "report-small") : #imageLiteral(resourceName: "flag-icon")
//                }
//
//                self.statusApi(status: "4")
//            }
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
//                return
//            }
//            self.showAlert("Alert", message: "Are you sure you want to report this user?. Once Reported you will not able to see this user", style: .alert, actions: [okAction,cancel])
//
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReportDialog") as! ReportDialogViewController
            
            vc.modalPresentationStyle = .overFullScreen
            vc.dialogDelegate = self
            vc.name = nameUserLabel.text!
            
            let popover = vc.popoverPresentationController
            popover?.sourceView = self.view
            popover?.sourceRect = self.view.bounds
            popover?.delegate = self as? UIPopoverPresentationControllerDelegate
            vc.modalTransitionStyle = .crossDissolve
            
            self.present(vc, animated: true, completion:nil)
        }
        else{
            self.statusApi(status: "4")
        }
        
    }
    
    @IBAction func reloadButtonAction(_ sender: UIButton) {
        self.reloadImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 6/5))
        UIView.animate(withDuration: 0.4) {
            self.reloadImageView.transform = .identity
        }
    }
    
    @IBAction func moreBarButtonAction(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    //MARK: - Api
    func statusApi(status: String){
        if model.count == 0 {
            return
        }
        let param: Parameters = ["userID": standard.string(forKey: "userId") ?? "",
                                 "likedID": model[self.index ?? 0].userID ?? "",
                                 "status": "\(status)"]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "status", param: param, header: [:], success: { (json) in
            print(json)
            if json["status"].stringValue == "1"{
            if status == "1"{
                self.model[self.index ?? 0].liked = ((self.model[self.index ?? 0].liked ?? "0") == "0") ? "1" : "0"
                if ((self.model[self.index ?? 0].liked ?? "0") == "1"){
                    self.model[self.index ?? 0].unlike = "0"
                }
            }else if status == "2"{
                self.model[self.index ?? 0].unlike = ((self.model[self.index ?? 0].unlike ?? "0") == "0") ? "1" : "0"
                if ((self.model[self.index ?? 0].unlike ?? "0") == "1"){
                    self.model[self.index ?? 0].liked = "0"
                }
            }else if status == "3"{
                self.model[self.index ?? 0].setFavourite = ((self.model[self.index ?? 0].setFavourite ?? "0") == "0") ? "1" : "0"
            }else if status == "4"{
                self.model[self.index ?? 0].report = ((self.model[self.index ?? 0].report ?? "0") == "0") ? "1" : "0"
            }
//            self.fetchAllProfile(refresh: false)
            DispatchQueue.main.async {
                self.loadData()
            }
            }else{
                DispatchQueue.main.async {
                    self.loadData()
                }
                self.showalert(msg: json["message"].stringValue)
            }
            self.view.stopProgresshub()
            
        }) { (error) in
            print(error)
             self.showalert(msg: error)
            self.view.stopProgresshub()
        }
    }
    
    func fetchAllProfile(){
        let param : Parameters = ["userID": standard.string(forKey: "userId") ?? ""]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "Allprofile", param: param, header: [:], success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                if let items = json["data"].array{
                    self.model = items.map({AllProfileModel.init(json: $0)})
                }
                guard self.model.count != 0 else{
                    self.cardView.isHidden = true
//                    self.viewBottomheight.constant = 0
                    return
                }
                    DispatchQueue.main.async {
                        self.loadData()
                    }
            }else{
                self.showalert(msg: json["message"].stringValue)
            }
            self.cardView.reloadData()
             self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    
    //MARK: - Additional Functions
    ///function to load all Api Data in View
    func loadData(){
        self.nameUserLabel.text = model[self.index ?? 0].userName ?? ""
        self.onlineStatus.text = model[self.index ?? 0].last_active ?? ""
        self.rangeLabel.isHidden = !(self.showDistance ?? true)
        self.rangeLabel.text = (self.model[self.index ?? 0].distance ?? "") + " Miles Away"
        self.likeImageView.image = #imageLiteral(resourceName: "like-icon")
        self.unlikeImageView.image = #imageLiteral(resourceName: "unlike-icon")
        self.heartImageView.image = #imageLiteral(resourceName: "heart-icon")
        self.flagImageView.image = #imageLiteral(resourceName: "flag-icon")
        if (self.model[self.index ?? 0].liked ?? "1") == "1"{
            self.likeImageView.image = #imageLiteral(resourceName: "like-small")
           
        }
         if (self.model[self.index ?? 0].unlike ?? "1") == "1"{
            self.unlikeImageView.image = #imageLiteral(resourceName: "unlike-small")
            
        }
        if (self.model[self.index ?? 0].setFavourite ?? "1") == "1"{
            self.heartImageView.image = #imageLiteral(resourceName: "heart-orange-small")
        }
        if (model[self.index ?? 0].report ?? "1") == "1"{
            self.flagImageView.image = #imageLiteral(resourceName: "report-small")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var visibleRect = CGRect()
//        visibleRect.origin = cardView.frame.origin
//        visibleRect.size = cardView.bounds.size
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        guard let indexPath = cardView.indexPathForItem(at: visiblePoint) else { return }
//        print(indexPath)
//        self.index = indexPath.row
        DispatchQueue.main.async {
            self.loadData()
        }
    }
}

extension HomeViewController: ReportDialogDelegate {
    func reportDialogViewController(_ reportDialog: ReportDialogViewController, selected result: Int) {
        self.clickButtonAnimation {
            self.flagImageView.transform = .identity
            self.flagImageView.image = (self.flagImageView.image == #imageLiteral(resourceName: "flag-icon")) ? #imageLiteral(resourceName: "report-small") : #imageLiteral(resourceName: "flag-icon")
        }
        
        self.statusApi(status: "4")
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout -
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width
        return CGSize(width: width, height: height)
    }
}

//MARK:- VerticalSwipe Delegates & DataSource -
extension HomeViewController: VerticalCardSwiperDelegate, VerticalCardSwiperDatasource{
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return model.count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "HomeViewCell", for: index) as? HomeViewCell
//        cell?.videoImageView.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
        cell?.videoImageView.sd_setImage(with: URL(string: self.model[index].videoImage ?? ""), placeholderImage: #imageLiteral(resourceName: "crop"), options: .refreshCached, completed: { (image, error, cache, url) in
            if image != nil{
                cell?.videoImageView.image = image
            }else{
                cell?.videoImageView.image = #imageLiteral(resourceName: "crop")
            }
        })
        cell?.videoImageView.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: -1))
        // Handle play video button
        cell?.playVideoButtonAction = {
            self.playVideo(fileURL: self.model[index].videoUrl ?? "IMG_0101")
        }
        //get index
        self.index = index
        
        // Show profile page
        cell?.showProfileAction = {
            let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            profileVC.userId = self.model[index].userID ?? ""
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        cell?.showCommentAction = {        
            let commentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
            commentVC.receiverId = self.model[index].userID ?? ""
            
            let transition:CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
        return cell!
    }
    
    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        return CGSize(width: self.cardView.frame.width, height: self.cardView.frame.height)
    }

    func didScroll(verticalCardSwiperView: VerticalCardSwiperView) {
        var visibleRect = CGRect()
                visibleRect.origin = verticalCardSwiperView.contentOffset
                visibleRect.size = verticalCardSwiperView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                guard let indexPath = verticalCardSwiperView.indexPathForItem(at: visiblePoint) else { return }
//                print(indexPath)
                self.index = indexPath.row
        DispatchQueue.main.async {
            self.loadData()
        }
        
    }
}

// MARK: - ENSideMenuDelegate -

extension HomeViewController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        tapGeture.isEnabled = true
        swipeGeture.isEnabled = true
        disableUIView(isEnable: false)
        UIView.animate(withDuration: 0.2) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func sideMenuWillClose() {
        tapGeture.isEnabled = false
        swipeGeture.isEnabled = false
        disableUIView(isEnable: true)
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
