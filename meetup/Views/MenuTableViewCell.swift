//
//  MenuTableViewCell.swift
//  meetup
//
//  Created by An Phan on 3/24/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var optionNameLabel: UILabel!
    
    static let identifier = "MenuTableViewCell"
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
