//
//  VideoSettingsDialogViewController.swift
//  TV Escola Adult
//
//  Created by Mobile World on 2/26/19.
//  Copyright © 2019 Jenya Ivanova. All rights reserved.
//

import UIKit

protocol ReportDialogDelegate {
    func reportDialogViewController(_ reportDialog: ReportDialogViewController, selected result: Int)
}
class ReportDialogViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var dialogDelegate: ReportDialogDelegate!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        
        messageLabel.text = "We won't tell \(name)"
    }
    @IBAction func onInappropriateMessages(_ sender: Any) {
        dialogDelegate.reportDialogViewController(self, selected: 0)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onInappropriatePhotos(_ sender: Any) {
        dialogDelegate.reportDialogViewController(self, selected: 1)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onInappropriateVideos(_ sender: Any) {
        dialogDelegate.reportDialogViewController(self, selected: 2)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSpam(_ sender: Any) {
        dialogDelegate.reportDialogViewController(self, selected: 3)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
