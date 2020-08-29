//
//  IntroVideoViewController.swift
//  meetup
//
//  Created by mobileworld on 4/21/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import AVFoundation

class IntroVideoViewController: UIViewController
{
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 20
    }
    override func viewDidAppear(_ animated: Bool) {
//        AVMakeRect(aspectRatio:CGSize(width: view.frame.width, height: view.frame.height), insideRect: view.frame)
        let videoString:String? = Bundle.main.path(forResource: "LogoVideo", ofType: "mp4")
        guard let videoPath = videoString else {return}
        print(videoPath)
        videoView.configure(url: videoPath)
        videoView.isLoop = false
        videoView.play()
        NotificationCenter.default.addObserver(self, selector: #selector(onCompleted(_:)),
        name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    @objc func onCompleted(_ notification: Notification){
//        AppState.presentLogin()
        videoView.isHidden = true
    }    
    @IBAction func onStartButton(_ sender: Any) {
        standard.set(true, forKey: "welcome")
        AppState.presentLogin()
    }
}
