//
//  IndexTableViewCell.swift
//  meetup
//
//  Created by An Phan  on 4/2/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit

class IndexTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var lineFirstCell: UIView!
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  

}
