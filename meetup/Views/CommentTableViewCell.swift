//
//  CommentTableViewCell.swift
//  meetup
//
//  Created by An Phan on 3/26/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import Cosmos

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    
    
    static let identifier = "CommentTableViewCell"
    
    // MARK: - Variables
    var replyButtonAction: (() -> Void)?
    var reportButtonAction: (() -> Void)?
    let startDefault = "star-default"
    let startHightLight = "star-hightlight"
    private let highlightCount: Int = 3
    var rating: Int?
    // MARK: - View life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        userImageView.roundRadius()
        prepareCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    // MARK: - Private Methods
  
    private func prepareCollectionView() {
        let nib = UINib(nibName: RateCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: RateCollectionViewCell.identifier)
    }
    
    // MARK: - IBActions
    @IBAction func replyButtonAction(_ sender: UIButton) {
        replyButtonAction?()
    }
    
    @IBAction func reportButtonAction(_ sender: UIButton) {
        reportButtonAction?()
    }
}

extension CommentTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rating ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateCollectionViewCell.identifier, for: indexPath) as! RateCollectionViewCell
        cell.startImageView.image = UIImage(named: startHightLight)
        return cell
    }
}
