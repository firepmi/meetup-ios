//
//  DeleteAccountDialogViewController.swift
//  meetup
//
//  Created by mobileworld on 7/30/20.
//  Copyright © 2020 developer. All rights reserved.
//


import UIKit

protocol DeleteAccountDialogDelegate {
    func deleteAccountDialogViewController(_ deleteAccountDialog: DeleteAccountDialogViewController, selected result: Int)
}
class DeleteAccountDialogViewController: UIViewController {
       
    @IBOutlet weak var option1ImageView: UIImageView!
    @IBOutlet weak var option2ImageView: UIImageView!
    @IBOutlet weak var option3ImageView: UIImageView!
    @IBOutlet weak var option4ImageView: UIImageView!
    @IBOutlet weak var option5ImageView: UIImageView!
    @IBOutlet weak var option6ImageView: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    var dialogDelegate: DeleteAccountDialogDelegate!
    var result = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onOptionSelected(_ sender: UIButton) {
        result = sender.tag - 100
        print("result: \(result)")
        option1ImageView.image = UIImage(named: "icon_not_selected.png")
        option2ImageView.image = UIImage(named: "icon_not_selected.png")
        option3ImageView.image = UIImage(named: "icon_not_selected.png")
        option4ImageView.image = UIImage(named: "icon_not_selected.png")
        option5ImageView.image = UIImage(named: "icon_not_selected.png")
        option6ImageView.image = UIImage(named: "icon_not_selected.png")
        switch result {
        case 0:
            option1ImageView.image = UIImage(named: "icon_selected.png")
            buttonLabel.text = "Remove from Search"
        case 1:
            option2ImageView.image = UIImage(named: "icon_selected.png")
            buttonLabel.text = "Hide Account"
        case 2:
            option3ImageView.image = UIImage(named: "icon_selected.png")
            buttonLabel.text = "Clear Contents"
        case 3:
            option4ImageView.image = UIImage(named: "icon_selected.png")
            buttonLabel.text = "Notification off"
        case 4:
            option5ImageView.image = UIImage(named: "icon_selected.png")
            buttonLabel.text = "Sign Out"
        case 5:
            option6ImageView.image = UIImage(named: "icon_selected.png")
            buttonLabel.text = "Delete Account"
        default:
            break
        }
        
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onConfirm(_ sender: Any) {
        dialogDelegate.deleteAccountDialogViewController(self, selected: result)
        dismiss(animated: true, completion: nil)
    }
    
}

