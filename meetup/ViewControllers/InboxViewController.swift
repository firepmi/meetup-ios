//
//  IndexViewController.swift
//  meetup
//
//  Created by An Phan  on 4/2/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import SDWebImage

class InboxViewController: UIViewController {
    
    // MARK: - Private var/let
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    
    //MARK: - Variables
    var matchesModel = [MatchesModel]()
    var items = [Conversation]()
    var selectedUser: User?
    var SelectedType = String()
    var userArray = NSArray()
    var coachArray = NSArray()
    var sortedSections = [String]()
    var getChatArr = NSMutableArray()
    var getFilterChatArr = NSMutableArray()
    var getParentArr = NSArray()
    var serachResponseArray = NSArray()
    
    var filterMessage = [Message]()
    var objectMessage = [Message]()
    
    // MARK: - Outlets
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inbox"
        prepareNavigationBar()
        addTapGeture()
        addSwipeGeture()
        self.sideMenuController()?.sideMenu?.delegate = self
        (self.segment.selectedSegmentIndex == 0) ? self.fetchMatchesApi() : nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getChatWindows()
        navigationController?.isToolbarHidden  = true
    }
    
    // MARK: - Private Methods
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
    
    private func prepareNavigationBar() {
        // Added right bar button
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "more-icon"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(moreBarButtonAction))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    // MARK: - @Objc Methods
    @objc func mainViewTapped(swipe: UISwipeGestureRecognizer) {
        hideSideMenuView()
    }
    
    @objc func moreBarButtonAction() {
        toggleSideMenuView()
    }
    
    //MARK: - IBActions
    @IBAction func segmentChanged(_ sender: Any) {
        (self.segment.selectedSegmentIndex == 0) ? self.fetchMatchesApi() : self.getChatWindows()
    }
    
    //MARK:- Other Methods
    //Downloads conversations
    func fetchData() {
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        
                        break
                    }
                }
            }
        }
    }
    func getChatWindows() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        //child("JUSTPlay_" + otherUserId!)
        ref.child("ChatWindow").child("MeetUp_" + standard.string(forKey: "userId")!).observe(.value) { (snapshot) in
            self.getChatArr.removeAllObjects()
            self.objectMessage.removeAll()
            self.filterMessage.removeAll()
            self.getFilterChatArr.removeAllObjects()
            if snapshot.childrenCount > 0 {
                for message in snapshot.children.allObjects as! [DataSnapshot] {
                    let messageObject = message.value as? [String: AnyObject]
                    let chatMessage = Message.init()
                    chatMessage.messageType = messageObject?["messageType"] as? String
                    chatMessage.text = messageObject?["text"] as? String
                    chatMessage.userImage = messageObject?["userProfilePic"] as? String
                    chatMessage.userName = messageObject?["userName"] as? String
                    chatMessage.time = messageObject?["time"] as! Int64
                    chatMessage.userId = messageObject?["userId"] as? String
                    self.getFilterChatArr.add(chatMessage)
                    self.getChatArr = self.getFilterChatArr
                    self.filterMessage.append(chatMessage)
                    self.objectMessage = self.filterMessage
                }
            }
            self.tableView.reloadData()
            
        }
    }
    
    
    //MARK: - Api's -
    func fetchMatchesApi(){
        let param: Parameters = ["userID": standard.string(forKey: "userId") ?? ""]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "MyMatchList", param: param, header: [:], success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                if let items = json["data"].array{
                    self.matchesModel = items.map({MatchesModel.init(json: $0)})
                }
            }
            self.tableView.reloadData()
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource -
extension InboxViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.segment.selectedSegmentIndex == 0) ? self.matchesModel.count : self.filterMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndexTableViewCell", for: indexPath) as! IndexTableViewCell
        if indexPath.row == 0 {
            cell.lineFirstCell.isHidden = false
        }
        if segment.selectedSegmentIndex == 0{
            cell.userNameLabel.text = self.matchesModel[indexPath.row].userName ?? ""
            cell.userMessageLabel.text = self.matchesModel[indexPath.row].aboutme ?? ""
            cell.userAvatarImage.sd_setHighlightedImage(with: URL(string: self.matchesModel[indexPath.row].profilePic ?? ""), options: SDWebImageOptions.refreshCached) { (image, error, Cache, url) in
                if image != nil{
                    cell.userAvatarImage.image = image
                }else{
                    cell.userAvatarImage.image = #imageLiteral(resourceName: "profilePlaceholder")
                }
            }
        }else{
            //            cell.userNameLabel.text = self.items[indexPath.row].lastMessage.UserName
            ////            cell.userAvatarImage.image = self.items[indexPath.row].lastMessage.image
            //            switch self.items[indexPath.row].lastMessage.type {
            //            case .text:
            //                let message = self.items[indexPath.row].lastMessage.content as! String
            //                cell.userMessageLabel.text = message
            //            case .location:
            //                cell.userMessageLabel.text = "Location"
            //            default:
            //                cell.userMessageLabel.text = "Media"
            //            }
            //             cell.userAvatarImage.image = self.items[indexPath.row].
            let message = self.filterMessage[indexPath.row]
            
            
            cell.userNameLabel.text = message.userName
            
            cell.userMessageLabel.text = message.text
            //    let timeStamp = message.time
            // cell.timeLbl.text =  self.getTimeFromTimeInterval(interval: timeStamp)
            //            let getImageUrl = message.userImage
            //            let urlStr = URL(string: getImageUrl ?? "")
            cell.userAvatarImage.sd_setImage(with: URL(string: (message.userImage ?? "")), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"), options: .refreshCached) { (image, error, cache, url) in
                if image != nil{
                    cell.userAvatarImage.image = image
                }else{
                    cell.userAvatarImage.image = #imageLiteral(resourceName: "profilePlaceholder")
                }
            }
            return cell
        }
        return cell
    }
}

// MARK: - UITableViewDelegate -
extension InboxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment.selectedSegmentIndex == 0{
            let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            profileVC.userId = self.matchesModel[indexPath.row].userID ?? ""
            self.navigationController?.pushViewController(profileVC, animated: true)
        }else{
            //            let chatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            //            chatVC.currentUserId = self.items[indexPath.row].UserID
            //            chatVC.currentUserName = self.items[indexPath.row].lastMessage.UserName ?? ""
            //            self.navigationController?.pushViewController(chatVC, animated: true)
            let message = self.filterMessage[indexPath.row]
            let chatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            chatVC.otherUserName = message.userName ?? ""
            chatVC.otherUserImage = message.userImage ?? ""
            chatVC.otherUserId = message.userId
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}

// MARK: - ENSideMenuDelegate -
extension InboxViewController: ENSideMenuDelegate {
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
