//
//  VideoPlayerView.swift
//  vivecatv
//
//  Created by Solar Jang on 9/21/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class VideoPlayerView: UIView {
    
    var fullscreen:Bool?
    var padding:CGFloat = 0
    var titleLabel:UILabel?
    var airplayIsActiveView:AirplayActiveView?
    var playerControlBar:UIView?
    var playPauseButton:UIButton?
    var fullScreenButton:UIButton?
    var videoScrubber:UISlider?
    var currentPositionLabel:UILabel?
    var timeLeftLabel:UILabel?
    var progressView:UIProgressView?
    var shareButton:UIButton?
    var controlsEdgeInsets:UIEdgeInsets?
    var activityIndicator:UIActivityIndicatorView?
    var volumnView:MPVolumeView?
    var airplayButton:UIButton?
    
    var playerLayer: AVPlayerLayer{
        return layer as! AVPlayerLayer
    }
    
    override class func layerClass() -> AnyClass
    {
        return AVPlayerLayer.self
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.airplayIsActiveView = AirplayActiveView(frame: CGRectZero)
        self.airplayIsActiveView?.hidden = true
        self.addSubview(self.airplayIsActiveView!)
        
        
        self.titleLabel = UILabel(frame: CGRectZero)
        self.titleLabel?.font = UIFont(name: "Forza-Medium", size: 16)
        self.titleLabel?.textColor = UIColor.whiteColor()
        self.titleLabel?.backgroundColor = UIColor.clearColor()
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.addSubview(self.titleLabel!)
        
        self.playerControlBar = UIView()
        self.playerControlBar?.opaque = false
        self.playerControlBar?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.fullScreenButton = UIButton()
        self.fullScreenButton?.setImage(UIImage(named: "fullscreen-button.png"), forState: UIControlState.Normal)
        self.fullScreenButton?.showsTouchWhenHighlighted = true
        self.playerControlBar?.addSubview(self.fullScreenButton!)
        
        self.progressView = UIProgressView()
        self.progressView?.progressTintColor = UIColor(red: 31.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 1)
        self.progressView?.trackTintColor = UIColor.darkGrayColor()
        self.playerControlBar?.addSubview(self.progressView!)
        
        self.videoScrubber = UISlider()
        self.videoScrubber?.minimumTrackTintColor = UIColor.redColor()
        self.videoScrubber?.setMaximumTrackImage(UIImage(named: "transparentBar.png"), forState: UIControlState.Normal)
        self.playerControlBar?.addSubview(self.videoScrubber!)
        
        self.volumnView = MPVolumeView()
        self.volumnView?.showsRouteButton = true
        self.volumnView?.showsVolumeSlider = false
        
        self.playerControlBar?.addSubview(self.volumnView!)
        
        
        for(var i:Int=0; i<self.volumnView?.subviews.count; i++)
        {
            let button:AnyObject = self.volumnView?.subviews[i] as! AnyObject
            
            if(!button.isKindOfClass(UIButton))
            {
                continue
            }
            
//            button.addObserver(self, forKeyPath: "alpha", options: NSKeyValueObservingOptions.New, context: nil)
            
            self.airplayButton = button as? UIButton
        }
        
        self.currentPositionLabel = UILabel()
        self.currentPositionLabel?.backgroundColor = UIColor.clearColor()
        self.currentPositionLabel?.textColor = UIColor.whiteColor()
        self.currentPositionLabel?.font = UIFont(name: "DINRoundCompPro", size: 14)
        self.currentPositionLabel?.textAlignment = NSTextAlignment.Center
        self.playerControlBar?.addSubview(self.currentPositionLabel!)
        
        self.timeLeftLabel = UILabel()
        self.timeLeftLabel?.backgroundColor = UIColor.clearColor()
        self.timeLeftLabel?.textColor = UIColor.whiteColor()
        self.timeLeftLabel?.font = UIFont(name: "DINRoundCompPro", size: 14)
        self.timeLeftLabel?.textAlignment = NSTextAlignment.Center
        self.playerControlBar?.addSubview(self.timeLeftLabel!)
        
        self.playPauseButton = UIButton()
        self.playPauseButton?.setImage(UIImage(named: "play-button"), forState: UIControlState.Normal)
        self.playPauseButton?.showsTouchWhenHighlighted = true
        self.playerControlBar?.addSubview(self.playPauseButton!)
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.addSubview(self.activityIndicator!)
        
        self.controlsEdgeInsets = UIEdgeInsetsZero
        
        
    }
    
    
    
    
    let PLAYER_CONTROL_BAR_HEIGHT:CGFloat = 40
    let BUTTON_PADDING:CGFloat = 8
    let CURRENT_POSITION_WIDTH:CGFloat = 56
    let TIME_LEFT_WIDTH:CGFloat = 59
    let ALIGNMENT_FUZZ:CGFloat = 2
    let ROUTE_BUTTON_ALIGNMENT_FUZZ:CGFloat = 8
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds:CGRect = self.bounds
        let insetBounds:CGRect = CGRectInset(UIEdgeInsetsInsetRect(bounds, self.controlsEdgeInsets!), self.padding, self.padding)
        
        print(insetBounds)
        
        var titleString:String = ""
        
        if(self.titleLabel?.text != nil)
        {
            titleString = NSString(string: (self.titleLabel?.text)!) as String
        }
        
        let titleLabelSize = titleString.boundingRectWithSize(
            CGSizeMake(insetBounds.width, CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: self.titleLabel!.font],
            context: nil).size
        
        let shareImage = UIImage(named: "share-button.png")
        
        if(self.fullscreen == false)
        {
            let twoLineSize = "M\nM".boundingRectWithSize(
                CGSizeMake(insetBounds.width, CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.titleLabel!.font],
                context: nil).size

            self.autoresizesSubviews = true
            
            self.titleLabel?.frame = CGRectMake(insetBounds.origin.x + self.padding,
                insetBounds.origin.y,
                insetBounds.size.width,
                titleLabelSize.height)
            
            let playerFrame = CGRectMake(0,
                0,
                bounds.size.width,
                bounds.size.height - twoLineSize.height - self.padding - self.padding);
            
            self.airplayIsActiveView?.frame = playerFrame
            self.shareButton?.frame = CGRectMake(insetBounds.size.width - shareImage!.size.width, insetBounds.origin.y, shareImage!.size.width, shareImage!.size.height)
            
            
        }
        else
        {
            self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.titleLabel?.frame = CGRectMake(insetBounds.origin.x + self.padding,
                insetBounds.origin.y,
                insetBounds.size.width,
                titleLabelSize.height)
            self.airplayIsActiveView?.frame = bounds
            
            self.shareButton?.frame = CGRectMake(insetBounds.size.width - shareImage!.size.width, insetBounds.origin.y, shareImage!.size.width, shareImage!.size.height)
            
        }
        
        
        self.playerControlBar?.frame = CGRectMake(bounds.origin.x,
            bounds.size.height - PLAYER_CONTROL_BAR_HEIGHT,
            bounds.size.width,
            PLAYER_CONTROL_BAR_HEIGHT)
        
        
        self.activityIndicator?.frame = CGRectMake((bounds.size.width - self.activityIndicator!.frame.size.width)/2.0,
            (bounds.size.height - self.activityIndicator!.frame.size.width)/2.0,
            self.activityIndicator!.frame.size.width,
            self.activityIndicator!.frame.size.height)
        
        self.playPauseButton?.frame = CGRectMake(0,
            0,
            PLAYER_CONTROL_BAR_HEIGHT,
            PLAYER_CONTROL_BAR_HEIGHT)
        
        let fullScreenButtonFrame:CGRect =  CGRectMake(bounds.size.width - PLAYER_CONTROL_BAR_HEIGHT,
            0,
            PLAYER_CONTROL_BAR_HEIGHT,
            PLAYER_CONTROL_BAR_HEIGHT)
        self.fullScreenButton?.frame = fullScreenButtonFrame
        
        var routeButtonRect:CGRect = CGRectZero
        
        if(self.airplayButton?.alpha > 0)
        {
            if((self.volumnView?.respondsToSelector(Selector("routeButtonRectForBounds:"))) != nil)
            {
                routeButtonRect = (self.volumnView?.routeButtonRectForBounds(bounds))!
            }
            else
            {
                routeButtonRect = CGRectMake(0, 0, 24, 18)
            }
            
            
            self.volumnView?.frame = CGRectMake(CGRectGetMinX(fullScreenButtonFrame) - routeButtonRect.size.width
                - ROUTE_BUTTON_ALIGNMENT_FUZZ,
                PLAYER_CONTROL_BAR_HEIGHT / 2 - routeButtonRect.size.height / 2,
                routeButtonRect.size.width,
                routeButtonRect.size.height)
        }
        
        
        self.currentPositionLabel?.frame = CGRectMake(PLAYER_CONTROL_BAR_HEIGHT,
            ALIGNMENT_FUZZ,
            CURRENT_POSITION_WIDTH,
            PLAYER_CONTROL_BAR_HEIGHT)

        self.timeLeftLabel?.frame = CGRectMake(bounds.size.width - PLAYER_CONTROL_BAR_HEIGHT - TIME_LEFT_WIDTH
            - routeButtonRect.size.width,
            ALIGNMENT_FUZZ,
            TIME_LEFT_WIDTH,
            PLAYER_CONTROL_BAR_HEIGHT)
        
        let scrubberRect:CGRect = CGRectMake(PLAYER_CONTROL_BAR_HEIGHT + CURRENT_POSITION_WIDTH,
            0,
            bounds.size.width - (PLAYER_CONTROL_BAR_HEIGHT * 2) - TIME_LEFT_WIDTH -
                CURRENT_POSITION_WIDTH - (TIME_LEFT_WIDTH - CURRENT_POSITION_WIDTH)
                - routeButtonRect.size.width,
            PLAYER_CONTROL_BAR_HEIGHT)
        
        self.videoScrubber?.frame = scrubberRect
        self.progressView?.frame = (self.videoScrubber?.trackRectForBounds(scrubberRect))!

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title:String)
    {
        self.titleLabel?.text = title
        self.setNeedsDisplay()
    }
    func setFullscreen(fullscreen:Bool)
    {
        if(self.fullscreen == fullscreen)
        {
            return;
        }
        
        self.fullscreen = fullscreen
        
        self.setNeedsDisplay()
    }
    func heightForWidth(width:CGFloat) -> CGFloat
    {
        let titleLabelSize = "M\nM".boundingRectWithSize(
            CGSizeMake(width, CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: self.titleLabel!.font],
            context: nil).size
        return (width / 16 * 9) + titleLabelSize.height
    }
    func setPlayer(player:AVPlayer)
    {
        
//        let cglayer:CALayer = self.layer
//        let playLayer:AVPlayerLayer = self.playerLayer as! AVPlayerLayer
        self.playerLayer.player = player
//
//        
//        let playLayer:AVPlayerLayer = AVPlayerLayer(player: player)
//        self.layer.addSublayer(playLayer)
        
        
        self.airplayIsActiveView?.hidden = true
        
        self.addSubview(self.playerControlBar!)
    }
    func player() -> AVPlayer
    {
        let playLayer:AVPlayerLayer = self.layer as! AVPlayerLayer
        return playLayer.player!
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
        if(object!.isKindOfClass(UIButton) == true)
        {
            if((object as? UIButton) == self.airplayButton && keyPath == "alpha")
            {
                self.setNeedsLayout()
            }
        }

    }
    

}














