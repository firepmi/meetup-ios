//
//  HomeViewCell.swift
//  meetup
//
//  Created by developer on 09/05/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import VerticalCardSwiper

class HomeViewCell: CardCell {

    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var playVideoButton: UIButton!
    
//    static let identifier = "HomeCollectionViewCell"
    
    // MARK: - Variables
    var playVideoButtonAction: (() -> Void)?
    var showProfileAction: (() -> Void)?
    var showCommentAction:(() -> Void)?
    
    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        // Prepare collectionView
        containerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        addLeftSwipeGeture()
        addRightSwipeGeture()
    }
    
    // MARK: - Methods
    @objc func leftSwipeAction(swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .left {
            showProfileAction?()
        }
    }
    
    @objc func rightSwipeAction(swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .right {
            showCommentAction?()
        }
    }
    
    // MARK: - Private methods
    private func addLeftSwipeGeture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        rightSwipe.cancelsTouchesInView = true
        rightSwipe.direction = .left
        videoImageView.isUserInteractionEnabled = true
        videoImageView.addGestureRecognizer(rightSwipe)
    }
    
    private func addRightSwipeGeture() {
       
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction))
        rightSwipe.cancelsTouchesInView = true
        rightSwipe.direction = .right
        videoImageView.isUserInteractionEnabled = true
        videoImageView.addGestureRecognizer(rightSwipe)
    }
    
    // MARK: - IBActions
    @IBAction func playVideoButtonAction(_ sender: UIButton) {
        playVideoButtonAction?()
    }
}
