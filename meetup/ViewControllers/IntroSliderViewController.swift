//
//  IntroSliderViewController.swift
//  meetup
//
//  Created by mobileworld on 8/30/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import FSPagerView

class IntroSliderViewController: UIViewController
{
    
    @IBOutlet weak var pagerContentView: FSPagerView! {
        didSet {
            pagerContentView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var pageControl: FSPageControl!{
        didSet {
            self.pageControl.numberOfPages = self.images.count
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            pageControl.setFillColor(UIColor.init(red: 72/255.0, green: 58/255.0, blue: 133/255.0, alpha: 1), for: .selected)
            pageControl.setFillColor(UIColor.init(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1), for: .normal)
        }
    }
    
    let images = [
        UIImage(named: "intro1.png"),
        UIImage(named: "intro2.png"),
        UIImage(named: "intro3.png"),
        UIImage(named: "intro4.png"),
    ]
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    @IBAction func onBack(_ sender: Any) {
        if pageControl.currentPage != 0 {
            pagerContentView.scrollToItem(at: pageControl.currentPage - 1, animated: true)
            self.pageControl.currentPage = self.pageControl.currentPage - 1
        }
    }
    
    @IBAction func onNext(_ sender: Any) {
        if pageControl.currentPage < images.count - 1 {
//            pagerContentView.selectItem(at: pageControl.currentPage + 1, animated: true)
            pagerContentView.scrollToItem(at: pageControl.currentPage + 1, animated: true)
            self.pageControl.currentPage = self.pageControl.currentPage + 1
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension IntroSliderViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = images[index]
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.backgroundColor = .white
        cell.contentView.layer.shadowRadius = 0
        return cell
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return false
    }
}

