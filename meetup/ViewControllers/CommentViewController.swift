//
//  CommentViewController.swift
//  meetup
//
//  Created by An Phan on 3/26/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cosmos
import StoreKit
import IQKeyboardManager
import SDWebImage

class CommentViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var rateCollectionView: UICollectionView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var blockPremiumView: UIView!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewRating: CosmosView!
    
    
    // MARK: - Private var/let
    private var highlightCount: Int = 3
    private var SidetapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    private var swipeGeture1: UISwipeGestureRecognizer!
    
    //MARK: - Variables
    let startDefault = "star-default"
    let startHightLight = "star-hightlight"
   
//    var blockStatus: Bool = false
    var receiverId: String?
    var products: [SKProduct] = []                               //"com.animalBooks.arabic"
    var modelComment = [CommentsModel]()
    
    // MARK: - View life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().isEnabled = false
        userImageView.roundRadius()
        prepareNavigationBar()
        gradientOfNavigationBar()
        prepareCollectionView()
        prepareTableView()
        commentTableView.clipsToBounds = false
        commentTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 17, bottom: 30, right: -17)
        self.commentTableView.tableFooterView = UIView()
//        self.sideMenuController()?.sideMenu?.delegate = self
        addTransactionPop()
        self.viewRating.rating = 2
        self.viewShadow.isHidden = true
                
        addSideTapGesture()
        addTapGesture()
        addSwipeGeture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRestorePurchaseNotification(_:)),
                                               name: .IAPHelperRestorePurchaseNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.fetchCommentApi()
            self.fetchproducts()
        }
        setScrollIndicatorColor(color: UIColor(hexString: "FD6666"))
        //commentTableView.indicatorStyle =  UIScrollView.IndicatorStyle.black
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
    }
    
    // MARK: - Methods
    func setScrollIndicatorColor(color: UIColor)
    {
        for view in self.commentTableView.subviews {
            if view.isKind(of: UIImageView.self),
                let imageView = view as? UIImageView,
                let image = imageView.image  {
                imageView.frame.size.width = 10
                imageView.tintColor = color
                imageView.image = image.withRenderingMode(.alwaysTemplate)
//                view.frame.size.width = 10
                //view.backgroundColor = color
                
            }
        }
        self.commentTableView.flashScrollIndicators()
    }
    
    func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        self.viewShadow.addGestureRecognizer(tap)
    }
    
    
    //MARK:- @objc Methods
    @objc func moreBarButtonAction() {
        self.view.endEditing(true)
        toggleSideMenuView()
    }
    
    @objc func tapPressed(){
        if self.viewComment != nil{
            self.viewComment.removeFromSuperview()
            self.viewShadow.isHidden = true
        }
    }
    
    @objc func likeComment(_ sender : UIButton){
        self.likeCommentApi(index: sender.tag)
    }
    
    @objc func mainViewTapped(swipe: UISwipeGestureRecognizer) {
        hideSideMenuView()
        hideMenuOption()
    }
    @objc func leftSwipe(swipe: UISwipeGestureRecognizer) {
//        dismiss(animated: true, completion: nil)
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: true)
    }
    @objc func SidemainViewTapped(swipe: UISwipeGestureRecognizer){
        hideSideMenuView()
        hideMenuOption()
    }
    
    // MARK: - Private methods
    private func addTransactionPop(){
        let transition:CATransition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
    }
    
    private func prepareNavigationBar() {
        // Added right bar button
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "more-icon"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(moreBarButtonAction))
        navigationItem.rightBarButtonItem = moreBarButtonItem
        self.title = "Comments"
    }
    
    private func prepareTableView() {
        let nib = UINib(nibName: CommentTableViewCell.identifier, bundle: nil)
        commentTableView.register(nib, forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
    
    private func prepareCollectionView() {
        let nib = UINib(nibName: RateCollectionViewCell.identifier, bundle: nil)
        rateCollectionView.register(nib, forCellWithReuseIdentifier: RateCollectionViewCell.identifier)
    }
    
    private func addSideTapGesture() {
        SidetapGeture = UITapGestureRecognizer(target: self, action: #selector(SidemainViewTapped))
        SidetapGeture.isEnabled = false
        view.addGestureRecognizer(SidetapGeture)
    }
    
    private func addSwipeGeture() {
        swipeGeture = UISwipeGestureRecognizer(target: self, action: #selector(mainViewTapped))
        swipeGeture.isEnabled = false
        swipeGeture.direction = .right
        view.addGestureRecognizer(swipeGeture)
        
        swipeGeture1 = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        swipeGeture1.isEnabled = true
        swipeGeture1.direction = .left
        blockPremiumView.addGestureRecognizer(swipeGeture1)
        
    }
    
    private func hideMenuOption() {
        //        collectionViewTrailingConstraint.constant = spacingOfCollectionView
        //        collectionViewLeadingConstraint.constant = spacingOfCollectionView
        UIView.animate(withDuration: 0.4) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func UpgrateToPrimiumAction(_ sender: UIButton) {
        guard
        let index = products.firstIndex(where: { product -> Bool in
            product.productIdentifier == SubscriptionProducts.subscriptionID
        })
        else { return }
        SubscriptionProducts.store.buyProduct(self.products[index])
//        blockPremiumView.isHidden = true
    }
    
    @IBAction func restorePrimiun(_ sender: Any) {
        SubscriptionProducts.store.restorePurchases()
    }
    
    
    @IBAction func postCommentAction(_ sender: Any) {
        self.viewComment.frame = CGRect.init(x: 15, y: self.view.frame.height / 2 - 100, width: self.view.frame.width - 30, height: 200)
        self.viewComment.center = self.view.center
        self.txtViewComment.backgroundColor = UIColor.init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        self.txtViewComment.becomeFirstResponder()
        self.txtViewComment.text = ""
        self.viewShadow.isHidden = false
        self.view.addSubview(viewComment)
    }
    
    @IBAction func postAction(_ sender: Any) {
        guard !(self.txtViewComment.text == "")else{
            return
        }
        self.viewShadow.isHidden = true
        self.postCommentApi()
        self.viewComment.removeFromSuperview()
    }
    
    
    //MARK: - Api
    //function to post a new comment on user profile.
    func postCommentApi(){
        let param: Parameters = [
            "reciverID": self.receiverId ?? "",
            "senderID" : standard.string(forKey: "userId") ?? "",
            "comment" : self.txtViewComment.text ?? "",
            "rating" : "\(Int(viewRating.rating))"
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "PostComment", param: param, header: [:], success: { (json) in
            print(json)
            self.view.stopProgresshub()
            DispatchQueue.main.async {
                self.fetchCommentApi()
            }
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    ///function to fetch all previous Comment done .
    func fetchCommentApi(){
        let param: Parameters = [
            "userID": self.receiverId ?? "",
            "my_id": standard.string(forKey: "userId") ?? ""
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "FetchComment", param: param, header: [:], success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                if let items = json["data"]["comment"].array{
                    self.modelComment = items.map({CommentsModel.init(json: $0)})
                }
                self.userNameLabel.text = json["data"]["profile"]["userName"].stringValue
                self.viewRating.rating = json["data"]["profile"]["Rating"].doubleValue
                self.highlightCount = (json["data"]["profile"]["Rating"].intValue)
                self.jobNameLabel.text = (json["data"]["profile"]["aboutMe"].stringValue)
                self.commentCountLabel.text = "(\(self.modelComment.count) Comments)"
                self.commentCountLabel.isHidden = (self.modelComment.count == 0) ? true : false
                DispatchQueue.main.async {
                    self.userImageView.sd_setImage(with: URL(string: json["data"]["profile"]["profile_image"].stringValue), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"), options: .refreshCached, completed: { (image, error, cache, url) in
                        if image != nil{
                            self.userImageView.image = image
                        }else{
                             self.userImageView.image = #imageLiteral(resourceName: "profilePlaceholder")
                        }
                    })
                    if self.modelComment.count == 0{
                        self.commentTableView.isHidden = true
                    }else{
                        self.commentTableView.isHidden = false
                    }
                    self.commentTableView.reloadData()
                    self.rateCollectionView.reloadData()
                }
            }
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    ///function to save payment status in database.
    func paymentApi(status: String){
        let param: Parameters = [
            "userID" : standard.string(forKey: "userId") ?? "",
            "PaymentStatus" : status
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "PaymentStatus", param: param, header: [:], success: { (json) in
            print(json)
            self.view.stopProgresshub()
            if status == "1" {
                standard.set(true, forKey: "paymentStatus")
            }
            else {
                standard.set(true, forKey: "paymentStatus")
            }
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    ///function to like a Comment
    func likeCommentApi(index: Int){
        //if user Can't like his own comment
//        guard (self.modelComment[index].comment_user_id ?? "") != (standard.string(forKey: "userId") ?? "")else{
//            return
//        }
        let param :Parameters = [
            "comment_id": self.modelComment[index].comment_id ?? "",
            "user_id": self.modelComment[index].comment_user_id ?? "",
            "liker_id": standard.string(forKey: "userId") ?? ""
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "LikeUnlikeAComment", param: param, header: [:], success: { (json) in
            print(json)
            if self.modelComment[index].liked == "0"{
                self.modelComment[index].likes = (self.modelComment[index].likes ?? 0) + 1
                self.modelComment[index].liked = "1"
            }else{
                self.modelComment[index].likes = (self.modelComment[index].likes ?? 0) - 1
                self.modelComment[index].liked = "0"
            }
            self.commentTableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    
    //MARK:- InApp Purchase Methods
    func fetchproducts(){
        var test = false
        SubscriptionProducts.store.requestProducts({ [weak self] success, products in
            guard self != nil else { return }
            if success {
                print("Products count: \(products!.count)")
                self!.products = products!
                let isPro = SubscriptionProducts.store.isProductPurchased(SubscriptionProducts.subscriptionID) || test
                standard.set(isPro, forKey: "paymentStatus")
                print(SubscriptionProducts.subscriptionID, isPro)
            }
            DispatchQueue.main.async {
//                self!.blockPremiumView.isHidden = ((self!.receiverId ?? "") == standard.string(forKey: "userId") ?? "") ? true : ((standard.bool(forKey: "paymentStatus") ))
                self!.blockPremiumView.isHidden = standard.bool(forKey: "paymentStatus")
            }
        })
    }
           
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            let index = products.firstIndex(where: { product -> Bool in
                product.productIdentifier == productID
            })
            else { return }
        let isPro = SubscriptionProducts.store.isProductPurchased(SubscriptionProducts.subscriptionID)
        if isPro {
            //TODO: Add here
            let alert = UIAlertController(title: "Premium Membership", message: "Successfully Upgraded to Premium Membership!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                self.paymentApi(status: "1")
                standard.set(isPro, forKey: "paymentStatus")
            }))
            self.present(alert, animated: true);
        }
    }
    @objc func handleRestorePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            let index = products.firstIndex(where: { product -> Bool in
                product.productIdentifier == productID
            })
            else { return }
        let isPro = SubscriptionProducts.store.isProductPurchased(SubscriptionProducts.subscriptionID)
        if isPro {
            //TODO: add here
            let alert = UIAlertController(title: "Premium Membership", message: "Successfully Restored to Premium Membership!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                self.paymentApi(status: "1")
                standard.set(isPro, forKey: "paymentStatus")
            }))
            self.present(alert, animated: true);
        }
        else {
            let alert = UIAlertController(title: "Premium Membership", message: "Restored your purchase Successful but could not find the record you purchased before ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                
            }))
            self.present(alert, animated: true);
        }
    }
}
// MARK: - UITableViewDataSource -

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.replyButtonAction = {
            let creditVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReplyCommentVC") as? ReplyCommentViewController
            creditVC?.modelComment = self.modelComment[indexPath.row]
            self.navigationController?.pushViewController(creditVC!, animated: true)
        }
        cell.dateLabel.text = self.dateConverter(string: self.modelComment[indexPath.row].createDate ?? "")
        cell.descriptionLabel.text = self.modelComment[indexPath.row].comment ?? ""
        cell.userImageView.sd_setImage(with: URL(string: self.modelComment[indexPath.row].profilePic ?? ""), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"), options: .refreshCached, completed: { (image, error, cache, url) in
            if image != nil{
                cell.userImageView.image = image
            }else{
                cell.userImageView.image = #imageLiteral(resourceName: "profilePlaceholder")
            }
        })
        cell.heartButton.setImage(((self.modelComment[indexPath.row].liked ?? "0") == "0") ? #imageLiteral(resourceName: "imgHeart-Gray-Small") : #imageLiteral(resourceName: "heart-orange-small"), for: .normal)
        cell.heartButton.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
        cell.heartButton.tag = indexPath.row
        cell.userNameLabel.text = self.modelComment[indexPath.row].userName ?? ""
        cell.ratingView.rating = Double(self.modelComment[indexPath.row].rating ?? 0)
        cell.rating = Int(self.modelComment[indexPath.row].rating ?? 0)
        cell.likeCountLabel.text = "\(self.modelComment[indexPath.row].likes ?? 0) likes"
        return cell
    }
}

// MARK:- UICollectionViewDelegate & UICollection -

extension CommentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateCollectionViewCell.identifier, for: indexPath) as! RateCollectionViewCell
        cell.startImageView.image = UIImage(named: indexPath.row < highlightCount ? startHightLight : startDefault)
        return cell
    }
}

// MARK: - ENSideMenuDelegate-
extension CommentViewController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        //        self.hideSideMenuView()
        SidetapGeture.isEnabled = true
        swipeGeture.isEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func sideMenuWillClose() {
        SidetapGeture.isEnabled = false
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
