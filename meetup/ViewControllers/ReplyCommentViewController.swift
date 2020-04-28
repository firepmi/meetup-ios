//
//  ReplyCommentViewController.swift
//  meetup
//
//  Created by An Phan  on 3/30/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
class ReplyCommentViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var replyview: UIView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var commentLikes: UILabel!
    @IBOutlet weak var tableReply: UITableView!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var btnSeeMoreHeight: NSLayoutConstraint!
    
    //MARK: - Variables
   
    var modelComment = CommentsModel.init(json: JSON(JSON.self))
    var replyModel = [ReplyCommentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewShadow?.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        self.viewShadow?.addGestureRecognizer(tap)
        DispatchQueue.main.async {
            self.loadData()
            self.fetchAllReplyApi()
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Objc method
    @objc func tapPressed(){
        if self.replyview != nil{
            self.replyview.removeFromSuperview()
            self.viewShadow?.isHidden = true
        }
    }
    
    @objc func likeReply(_ sender: UIButton){
        self.likeReplyApi(index: sender.tag)
        
    }
    
    //MARK:- Actions
    @IBAction func replyAction(_ sender: Any) {
        self.replyview.frame = CGRect.init(x: 15, y: self.view.frame.height / 2 - 100, width: self.view.frame.width - 30, height: 180)
        self.replyview.center = self.view.center
        self.txtView.backgroundColor = UIColor.init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        self.txtView.becomeFirstResponder()
        self.txtView.text = ""
        self.replyview.isHidden = false
        self.view.addSubview(replyview)
        self.viewShadow?.isHidden = false
    }
    
    @IBAction func postReplyAction(_ sender: Any) {
        guard !(self.txtView.text == "")else{
            return
        }
        self.postReply()
        self.viewShadow?.isHidden = true
        self.replyview.removeFromSuperview()
    }
    
    @IBAction func seeMoreAction(_ sender: UIButton) {
        self.lblComment.numberOfLines = 0
        self.btnSeeMoreHeight.constant = 0
    }
    
    //MARK: - Extra functions
    func loadData(){
        self.userProfile?.sd_setImage(with: URL(string: self.modelComment.profilePic ?? ""), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"), options: .refreshCached) { (image, error, cache, url) in
            if image != nil{
                self.userProfile.image = image
            }else{
                self.userProfile.image = #imageLiteral(resourceName: "profilePlaceholder")
            }
        }
        self.btnLikeCount.setImage(((self.modelComment.liked ?? "") == "0") ? #imageLiteral(resourceName: "imgHeart-Gray-Small") : #imageLiteral(resourceName: "heart-orange-small"), for: .normal)
        self.userName.text = self.modelComment.userName ?? ""
        self.lblComment.text = self.modelComment.comment ?? ""
        self.lblDate.text = self.modelComment.createDate ?? ""
        if lblComment.maxNumberOfLines == 1{
            self.btnSeeMoreHeight.constant = 0
        }else{
            
        }
        self.commentLikes.text = "\(self.modelComment.likes ?? 0)"
    }
    
    //MARK: - Api
    func fetchAllReplyApi(){
        let param : Parameters = [
            "comment_id": self.modelComment.comment_id ?? "",
            "UserID" : standard.string(forKey: "userId") ?? ""
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "FetchCommentReplies", param: param, header: [:], success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                if let items = json["data"]["comment_replies"].array{
                    self.replyModel = items.map({ReplyCommentModel.init(json: $0)})
                }
                self.tableReply.reloadData()
            }
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    func postReply(){
        let param : Parameters = [
            "comment_id" : self.modelComment.comment_id ?? "",
            "user_id" : self.modelComment.comment_user_id ?? "",
            "commenter_id": standard.string(forKey: "userId") ?? "",
            "comment_reply" : self.txtView.text
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "ReplyAComment", param: param, header: [:], success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                self.fetchAllReplyApi()
            }
            self.tableReply.reloadData()
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    func likeReplyApi(index: Int){
        let param: Parameters = [
            "comment_reply_id": self.replyModel[index].internalIdentifier ?? "",
            "user_id": self.modelComment.comment_user_id ?? "",
            "liker_id": standard.string(forKey: "userId") ?? ""
        ]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "LikeUnlikeACommentReply", param: param, header: [:], success: { (json) in
            print(json)
            if self.replyModel[index].liked == "0"{
                self.replyModel[index].likes = "\((Int(self.replyModel[index].likes ?? "0") ?? 0) + 1)"
                self.replyModel[index].liked = "1"
            }else{
                self.replyModel[index].likes = "\((Int(self.replyModel[index].likes ?? "0") ?? 0) - 1)"
                self.replyModel[index].liked = "0"
            }
            self.tableReply.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
}

//MARK: - TableViewDataSource -
extension ReplyCommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replyModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReplyCommentTableViewCell.identifier, for: indexPath) as! ReplyCommentTableViewCell
        cell.replyUserName.text = self.replyModel[indexPath.row].commentUserName ?? ""
        cell.lblreply.text = self.replyModel[indexPath.row].commentReply ?? ""
        cell.replyProfile.sd_setImage(with: URL(string: self.replyModel[indexPath.row].profilePic ?? ""), placeholderImage: #imageLiteral(resourceName: "crop"), options: .refreshCached) { (image, error, cache, url) in
            if image != nil{
                cell.replyProfile.image = image
            }else{
                cell.replyProfile.image = #imageLiteral(resourceName: "crop")
            }
        }
        cell.replyDate.text = self.replyModel[indexPath.row].createDate ?? ""
        cell.btnLike.setImage(((self.replyModel[indexPath.row].liked ?? "0") == "0") ? #imageLiteral(resourceName: "imgHeart-Gray-Small") : #imageLiteral(resourceName: "heart-orange-small"), for: .normal)
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(likeReply), for: .touchUpInside)
        cell.lblLikes.text = "\(self.replyModel[indexPath.row].likes ?? "0")" + " likes"
        return cell
    }
    
}


extension ReplyCommentViewController: UICollectionViewDelegate {
    
}
