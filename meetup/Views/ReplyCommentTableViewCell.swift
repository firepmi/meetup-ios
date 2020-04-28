//
//  ReplyCommentTableViewCell.swift
//  meetup
//
//  Created by An Phan  on 3/30/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit

class ReplyCommentTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var replyProfile: UIImageView!
    @IBOutlet weak var replyUserName: UILabel!
    @IBOutlet weak var replyDate: UILabel!
    @IBOutlet weak var lblreply: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    static let identifier = "ReplyCommentTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
