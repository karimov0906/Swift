//
//  StoriesCell.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 19/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

class CoverCell: UICollectionViewCell {

    @IBOutlet weak var artworkImageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    private var currentIndex: Int = 0
    private var delay: Int64 = 5
    private var onceToken:CoverCell!
    private var shouldStop:Bool = false
    
    var feeds:[Feed] = [] {
        didSet {
            shouldStop = true
            startAnimating()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        currentIndex = 0
        onceToken = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startAnimating() {
        if self.feeds.count == 0 || onceToken != self {
            return
        }
        
        self.artworkImageview.slideInFromBottom(0.64, completionDelegate: self)
        
        if self.currentIndex >= self.feeds.count {
            self.currentIndex = 0
        }
        let feed: Feed = self.feeds[self.currentIndex]
        
        //self.artworkImageview.image = nil
        if let imageURLString = feed.image
        {
            if let imageURL = NSURL(string: imageURLString) {
                self.artworkImageview.setImageWithURL(imageURL)
            }
        }
        
        if let artist = feed.artist {
            if let title = feed.title {
                self.titleLabel.text = title + " - " + artist
            }
            else {
                self.titleLabel.text = artist
            }
        }
        else {
            self.titleLabel.text = feed.title
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        currentIndex = (currentIndex + 1) % self.feeds.count
        if !shouldStop {
            delay = Int64(Double(rand()%8 + 4) * Double(NSEC_PER_SEC))
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay), dispatch_get_main_queue()) { () -> Void in
                self.startAnimating()
            }
        }
        else {
            shouldStop = false
        }
    }
}

extension UIView {
    // Name this function in a way that makes sense to you...
    // slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
    func slideInFromBottom(duration: NSTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromBottom
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
}
