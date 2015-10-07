//
//  VideoPlayerKit.swift
//  vivecatv
//
//  Created by Solar Jang on 9/21/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


private var playerViewControllerKVOContext = 0


class VideoPlayerKit: UIViewController, VideoPlayer, UIGestureRecognizerDelegate {

    var delegate:VideoPlayerDelegate?
    var currentVideoInfo:NSDictionary?
    var videoPlayerView:VideoPlayerView?
    var fullScreenModeToggled:Bool?
    var showStaticEndTime:Bool?
    var autoPlay:Bool?
    var allowPortratiFullScreen:Bool?
    var controlsEdgeInsets:UIEdgeInsets?
    var videoPlayer:AVPlayer?
    var containingView:UIView?
    
    var restoreVideoPlayStateAfterScrubbing:Bool?
    var scrubberTimeObserver:AnyObject?
    var playClockTimeObserver:AnyObject?
    var seekToZeroBeforePlay:Bool?
    var rotationIsLocked:Bool?
    var playerIsBuffering:Bool?
    var containingViewController:UIViewController?
    var topView:UIView?
    var isAlwaysFullscreen:Bool?
    var fullscreenViewController:FullScreenViewController?
    
    var previousBounds:CGRect?
    var hideTopViewWithControls:Bool?
    
    var playWhenReady:Bool?
    var scrubBuffering:Bool?
    var showShareOptions:Bool?
    
    
    let kVideoPlayerVideoChangedNotification:String = "VideoPlayerVideoChangedNotification"
    let kVideoPlayerWillHideControlsNotification:String = "VideoPlayerWillHideControlsNotitication"
    let kVideoPlayerWillShowControlsNotification:String = "VideoPlayerWillShowControlsNotification"
    let kTrackEventVideoStart:String = "Video Start"
    let kTrackEventVideoLiveStart:String = "Video Live Start"
    let kTrackEventVideoComplete:String = "Video Complete"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.fullScreenModeToggled = false
        
        self.currentVideoInfo = NSDictionary()
        
        self.videoPlayerView?.playPauseButton?.addTarget(self, action: Selector("playPauseHandler"), forControlEvents: UIControlEvents.TouchUpInside)
        self.videoPlayerView?.fullScreenButton?.addTarget(self, action: Selector("fullScreenButtonHandler"), forControlEvents: UIControlEvents.TouchUpInside)
        self.videoPlayerView?.shareButton?.addTarget(self, action:Selector("shareButtonHandler"), forControlEvents: UIControlEvents.TouchUpInside)
        self.videoPlayerView?.videoScrubber?.addTarget(self, action: Selector("scrubbingDidBegin"), forControlEvents: UIControlEvents.TouchDown)
        self.videoPlayerView?.videoScrubber?.addTarget(self, action: Selector("scrubberIsScrolling"), forControlEvents: UIControlEvents.ValueChanged)
        self.videoPlayerView?.videoScrubber?.addTarget(self, action: Selector("scrubbingDidEnd"), forControlEvents: [UIControlEvents.TouchCancel, UIControlEvents.TouchUpInside])
        
        let playerTouchedGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("videoTapHandler"))
        playerTouchedGesture.delegate = self
        self.videoPlayerView?.addGestureRecognizer(playerTouchedGesture)
        
        
        let pinchRecognizer:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("pinchGesture:"))
        pinchRecognizer.delegate = self
        self.view.addGestureRecognizer(pinchRecognizer);
        
        
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if(self.fullScreenModeToggled == true)
        {
            self.showShareOptions = false
//            self.minimizeVideo()
        }
        else
        {
            self.presentShareOptions()
        }
    }
    
    func videoTapHandler()
    {
        if(self.videoPlayerView?.playerControlBar?.alpha == 1)
        {
            self.hideControlsAnimated(true)
        }
        else
        {
            self.showControls()
        }
    }
    
    func gestureRecognizer(gestureRecognizer:UIGestureRecognizer, touch:UITouch) -> Bool
    {
        if((touch.view?.isDescendantOfView((self.videoPlayerView?.playerControlBar)!)) == true || touch.view?.isDescendantOfView((self.videoPlayerView?.shareButton)!) == true)
        {
            return false
        }
        
        return true
    }
    
    
    // targets
    func scrubbingDidEnd()
    {
        if(self.restoreVideoPlayStateAfterScrubbing == true)
        {
            self.restoreVideoPlayStateAfterScrubbing = false
            self.scrubBuffering = true
        }
        
        self.videoPlayerView?.activityIndicator?.startAnimating()
        
        self.showControls()
    }
    
    
    func scrubbingDidBegin()
    {
        if(self.isPlaying() == true)
        {
            self.videoPlayer?.pause()
            
            self.syncPlayPauseButtons()
            self.restoreVideoPlayStateAfterScrubbing = true
            
            self.showControls()
        }
    }
    func playerItemDuration() -> CMTime{
        
        if(self.videoPlayer?.status == AVPlayerStatus.ReadyToPlay)
        {
            return (self.videoPlayer?.currentItem?.duration)!
        }
        
        return kCMTimeInvalid
    }
    func scrubberIsScrolling()
    {
        let playerDuration:CMTime = self.playerItemDuration()
        
        let duration:Double = CMTimeGetSeconds(playerDuration)
        
        if(isfinite(duration))
        {
            
            var currentTime:Double = floor(duration * Double((self.videoPlayerView?.videoScrubber?.value)!))
            var timeLeft:Double = floor(duration - currentTime)
            
            if(currentTime <= 0)
            {
                currentTime = 0
                timeLeft = floor(duration)
            }
            let timeStr:String = self.stringFormattedTimeFromSeconds(currentTime)
            
            self.videoPlayerView?.currentPositionLabel?.text = "\(timeStr) "
            
            if(self.showStaticEndTime == false)
            {
                self.videoPlayerView?.timeLeftLabel?.text = "-\(self.stringFormattedTimeFromSeconds(timeLeft))"
            }
            else
            {
                self.videoPlayerView?.timeLeftLabel?.text = "\(self.stringFormattedTimeFromSeconds(timeLeft))"
            }
            
            self.videoPlayer?.seekToTime(CMTimeMakeWithSeconds(currentTime, Int32(NSEC_PER_SEC)))
            
        }
    }
    
    func stringFormattedTimeFromSeconds(seconds:Double) -> String
    {
        let date:NSDate = NSDate(timeIntervalSince1970: seconds)
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        if(seconds >= 3600)
        {
            formatter.dateFormat = "HH:mm:ss"
        }
        else
        {
            formatter.dateFormat = "mm:ss"
        }
        
        return formatter.stringFromDate(date)
    }
    
    func shareButtonHandler()
    {
        if(self.fullScreenModeToggled == true)
        {
            self.showShareOptions = true
            
            self.minimizeVideo()
        }
        else
        {
            self.presentShareOptions()
        }
    }
    func presentShareOptions()
    {
        self.showShareOptions = false
    }
    
    func fullScreenButtonHandler()
    {
        self.showControls()
        
        if(self.fullScreenModeToggled == true)
        {
            self.minimizeVideo()
        }
        else
        {
            self.launchFullScreen()
        }
    }
    func showControls()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(kVideoPlayerWillShowControlsNotification, object: self, userInfo: nil)
        
        UIView.animateWithDuration(0.4) { () -> Void in
            
            self.videoPlayerView?.playerControlBar?.alpha = 1
            self.videoPlayerView?.titleLabel?.alpha = 1
            self.videoPlayerView?.shareButton?.alpha = 1
        }
        
        if(self.fullScreenModeToggled == true)
        {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        }
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: Selector("hideControlsAnimated:"), object: true)
        
        if(self.isPlaying() == true)
        {
            self.performSelector(Selector("hideControlsAnimated:"), withObject: true, afterDelay: 4)
        }
    }
    func hideControlsAnimated(animated:Bool)
    {
        NSNotificationCenter.defaultCenter().postNotificationName(kVideoPlayerWillHideControlsNotification, object: self, userInfo: nil)
        
        if(animated == true)
        {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.videoPlayerView?.playerControlBar?.alpha = 0
                self.videoPlayerView?.titleLabel?.alpha = 0
                self.videoPlayerView?.shareButton?.alpha = 0
            })
            
            if(self.fullScreenModeToggled == true)
            {
                UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
            }
        }
        else
        {
            self.videoPlayerView?.playerControlBar?.alpha = 0
            self.videoPlayerView?.titleLabel?.alpha = 0
            self.videoPlayerView?.shareButton?.alpha = 0
            
            if(self.fullScreenModeToggled == true)
            {
                UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)

            }
        }
    }
    
    func playPauseHandler()
    {
        if(self.seekToZeroBeforePlay == true)
        {
            self.seekToZeroBeforePlay = false
            self.videoPlayer?.seekToTime(kCMTimeZero)
        }
        
        if(self.isPlaying() == true)
        {
            self.videoPlayer?.pause()
        }
        else
        {
            self.playVideo()
        }
        
        self.syncPlayPauseButtons()
    }
    func isPlaying() -> Bool{
    
        if(self.videoPlayer?.rate == 0)
        {
            return false
        }
        else
        {
            return true
        }
    }
    func playVideo()
    {
        if((self.view.superview) != nil)
        {
            self.playerIsBuffering = false
            self.scrubBuffering = false
            self.playWhenReady = false
            
            self.videoPlayer?.play()
            self.updatePlaybackProgress()
        }
    }
//    func isPlaying() -> Bool
//    {
//        return self.videoPlayer?.rate != 0
//    }
    func updatePlaybackProgress()
    {
        self.syncPlayPauseButtons()
        self.showControls()
        var interval:Double = 0.1
        
        let playerDuration:CMTime = self.playerItemDuration()
        
        if(CMTIME_IS_INVALID(playerDuration) == true)
        {
            return
        }
        
//        self.videoPlayerView?.videoScrubber?.hidden = true
//        self.videoPlayerView?.progressView?.hidden = true
        
        let duration:Double = CMTimeGetSeconds(playerDuration)
        
        if(CMTIME_IS_INDEFINITE(playerDuration) == true || duration <= 0)
        {
            self.videoPlayerView?.videoScrubber?.hidden = true
            self.videoPlayerView?.progressView?.hidden = true
            
            self.syncPlayClock()
            
            return
        }
        
        self.videoPlayerView?.videoScrubber?.hidden = false
        self.videoPlayerView?.progressView?.hidden = false
        

        let width:CGFloat = CGRectGetWidth((self.videoPlayerView?.videoScrubber?.bounds)!)
        interval = 0.5 * duration / Double(width)
        
        let vpvc:VideoPlayerKit = self
        
        self.scrubberTimeObserver = self.videoPlayer?.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(interval, Int32(NSEC_PER_SEC)), queue: nil, usingBlock: { (time1:CMTime) -> Void in
            vpvc.syncScrubber()
        })
        
        self.playClockTimeObserver = self.videoPlayer?.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(1, Int32(NSEC_PER_SEC)), queue: nil, usingBlock: { (time2:CMTime) -> Void in
            vpvc.syncPlayClock()
        })

        
    }
    func syncPlayClock()
    {
        let playerDuration:CMTime = self.playerItemDuration()
        if(CMTIME_IS_INVALID(playerDuration) == true)
        {
            return
        }
        
        if(CMTIME_IS_INDEFINITE(playerDuration) == true)
        {
            self.videoPlayerView?.currentPositionLabel?.text = "LIVE"
            self.videoPlayerView?.timeLeftLabel?.text = ""
            return
        }
        
        let duration:Double = CMTimeGetSeconds(playerDuration)
        if(isfinite(duration) == true)
        {
            var currentTime:Double = floor(CMTimeGetSeconds((self.videoPlayer?.currentTime())!))
            var timeLeft:Double = floor(duration - currentTime)
            
            if(currentTime <= 0)
            {
                currentTime = 0
                timeLeft = floor(duration)
            }
            
            self.videoPlayerView?.currentPositionLabel?.text = self.stringFormattedTimeFromSeconds(currentTime)
            
            if(self.showStaticEndTime == false)
            {
                self.videoPlayerView?.timeLeftLabel?.text = "-\(self.stringFormattedTimeFromSeconds(timeLeft))"
            }
            else
            {
                self.videoPlayerView?.timeLeftLabel?.text = self.stringFormattedTimeFromSeconds(duration)
            }
        }
        
    }
    func syncScrubber()
    {
        let playerDuration:CMTime = self.playerItemDuration()
        if(CMTIME_IS_INVALID(playerDuration) == true)
        {
            self.videoPlayerView?.videoScrubber?.minimumValue = 0
            return
        }
        
        let duration:Double = CMTimeGetSeconds(playerDuration)
        if(isfinite(duration) == true)
        {
            let minValue:Float = (self.videoPlayerView?.videoScrubber?.minimumValue)!
            let maxValue:Float = (self.videoPlayerView?.videoScrubber?.maximumValue)!
            let time:Double = CMTimeGetSeconds((self.videoPlayer?.currentTime())!)
            
            self.videoPlayerView?.videoScrubber?.value = (maxValue - minValue) * Float(time) / Float(duration) + minValue
        }
        
    }
    func syncPlayPauseButtons()
    {
        if(self.isPlaying() == true)
        {
            self.videoPlayerView?.playPauseButton?.setImage(UIImage(named: "pause-button.png"), forState: UIControlState.Normal)
        }
        else
        {
            self.videoPlayerView?.playPauseButton?.setImage(UIImage(named: "play-button.png"), forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTopView(topView:UIView)
    {
        self.topView = topView
        
        if(self.hideTopViewWithControls == true)
        {
            let weakTopView:UIView = self.topView!
            
            NSNotificationCenter.defaultCenter().removeObserver(self)
            NSNotificationCenter.defaultCenter().addObserverForName(kVideoPlayerWillHideControlsNotification, object: self, queue: NSOperationQueue.mainQueue(), usingBlock: { (not:NSNotification) -> Void in
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    weakTopView.alpha = 0
                })
            })
            
            NSNotificationCenter.defaultCenter().addObserverForName(kVideoPlayerWillShowControlsNotification, object: self, queue: NSOperationQueue.mainQueue(), usingBlock: { (not:NSNotification) -> Void in
                
                UIView.animateWithDuration(0.0, animations: { () -> Void in
                    weakTopView.alpha = 1
                })
            })
        }
    }
    
    func initWithContainingViewController(containingViewController:UIViewController, topView:UIView?, hideTopViewWithControls:Bool) -> AnyObject
    {
        
        self.containingViewController = containingViewController
        self.hideTopViewWithControls = hideTopViewWithControls
        self.topView = topView
        
        return self
    }
    
    
    
    func videoPlayerWithContainingViewController(containingViewController:UIViewController, topView:UIView?, hideTopViewWithControls:Bool) -> VideoPlayerKit
    {
        let videoPlayerKit:VideoPlayerKit = VideoPlayerKit();
        videoPlayerKit.initWithContainingViewController(containingViewController, topView: topView, hideTopViewWithControls: hideTopViewWithControls)
        
        return videoPlayerKit
    }
    
    func setControlsEdgeInsets(controlsEdgeInsets:UIEdgeInsets)
    {
        
        if(self.videoPlayerView == nil)
        {
            self.videoPlayerView = VideoPlayerView(frame: CGRectZero)
        
        }
        
        self.controlsEdgeInsets = controlsEdgeInsets
        self.videoPlayerView?.controlsEdgeInsets = self.controlsEdgeInsets
        
        self.view.setNeedsLayout()
        
    }
    
    func removeObserversFromVideoPlayerItem()
    {
//        self.videoPlayer?.currentItem?.removeObserver(self, forKeyPath: "status")
        self.videoPlayer?.currentItem?.removeObserver(self, forKeyPath: "status", context: nil)
//        self.videoPlayer?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        self.videoPlayer?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
        self.videoPlayer?.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
        self.videoPlayer?.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        self.videoPlayer?.removeObserver(self, forKeyPath: "externalPlaybackActive", context: nil)
        self.videoPlayer?.removeObserver(self, forKeyPath: "airPlayVideoActive", context: nil)
        
        
        //self.videoPlayerView?.removeObserver(self.videoPlayerView!, forKeyPath: "alpha")
        //alpha
    }
    
    
    override func loadView() {
        
        if(self.videoPlayerView == nil)
        {
            self.videoPlayerView = VideoPlayerView(frame: CGRectZero)
            
        }
        
        self.view = self.videoPlayerView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // protocol
    func playVideoWithTitle(title:String, url:NSURL, videoID:String?, shareURL:String?, streaming:Bool, playInFullScreen:Bool)
    {
        
        self.videoPlayer?.pause()
        
        self.videoPlayerView?.activityIndicator?.startAnimating()
        
        self.videoPlayerView?.progressView?.progress = 0
        self.showControls()
        
        var vidID:String = ""
        
        if(videoID == nil)
        {
            vidID = ""
        }
        else
        {
            vidID = videoID!
        }
        let tURL:NSURL = url
        
        print(shareURL)
        
//        if(shareURL != nil)
//        {
//            tURL = shareURL
//        }
        self.currentVideoInfo = ["title":title, "videoID":vidID, "isStreaming":streaming, "shareURL":tURL]
        
        
        NSNotificationCenter.defaultCenter().postNotificationName(kVideoPlayerVideoChangedNotification, object: self, userInfo: self.currentVideoInfo! as [NSObject : AnyObject])
        
        
        
        if(streaming == true)
        {
            self.delegate?.trackEvent(kTrackEventVideoLiveStart, videoID: vidID, title: title)
        }
        else
        {
            self.delegate?.trackEvent(kTrackEventVideoStart, videoID: vidID, title: title)
        }
        
        self.videoPlayerView?.currentPositionLabel?.text = ""
        self.videoPlayerView?.timeLeftLabel?.text = ""
        self.videoPlayerView?.videoScrubber?.value = 0
        
        self.videoPlayerView?.setTitle(title)
        
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [MPMediaItemPropertyTitle: title]
        
        self.setURL(url)
//        self.videoPlayerView?.backgroundColor = UIColor.redColor()

        
        let playerItem:AVPlayerItem = AVPlayerItem(URL: url)
        
        
        if(self.videoPlayer == nil)
        {
            self.videoPlayer = AVPlayer(playerItem: playerItem)
//            self.videoPlayerView?.addSubview(self.videoPlayer);
        }
        
        self.syncPlayPauseButtons()
        
        if(playInFullScreen == true)
        {
            self.isAlwaysFullscreen = true
            self.launchFullScreen()
        }
    }
    
    
    func setURL(url:NSURL)
    {
        let playerItem:AVPlayerItem = AVPlayerItem(URL: url)
        
        if(self.videoPlayer == nil)
        {
            self.videoPlayer = AVPlayer(playerItem: playerItem)
            self.videoPlayer?.allowsExternalPlayback = true
            self.videoPlayer?.usesExternalPlaybackWhileExternalScreenIsActive = true
            
            if(self.videoPlayer?.respondsToSelector(Selector("setAllowsExternalPlayback:")) == true)
            {
                self.videoPlayer?.allowsExternalPlayback = true
            }
            
            self.videoPlayerView?.setPlayer(self.videoPlayer!)
            
        }
        else
        {
            self.removeObserversFromVideoPlayerItem()
            self.videoPlayer?.replaceCurrentItemWithPlayerItem(playerItem)
        }
        
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.New, context: nil)
        playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.New, context: nil)
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.New, context: nil)

        self.videoPlayer?.addObserver(self, forKeyPath: "airPlayVideoActive", options: NSKeyValueObservingOptions.New, context: nil)
        self.videoPlayer?.addObserver(self, forKeyPath: "externalPlaybackActive", options: NSKeyValueObservingOptions.New, context: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerItemDidReachEnd:"), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.videoPlayer?.currentItem)
        
    }
    func playerItemDidReachEnd(notification:NSNotification)
    {
        self.syncPlayPauseButtons()
        
        self.seekToZeroBeforePlay = true
        
        self.delegate?.trackEvent(kTrackEventVideoComplete, videoID: self.currentVideoInfo!["videoID"] as! String, title: self.currentVideoInfo!["title"] as! String)
    }
    func showCannotFetchStreamError()
    {
//        let alerView:UIAlertView = UIAlertView(title: "Sad Panda says...", message: "I can't seem to fetch that stream. Please try again later.", delegate: NilLiteralConvertible, cancelButtonTitle: "Bummer!", otherButtonTitles: NilLiteralConvertible, NilLiteralConvertible)
//        alerView.show()
    }
    func launchFullScreen()
    {
        
        if(self.fullScreenModeToggled == false)
        {
            self.fullScreenModeToggled = true
            
            if(self.isAlwaysFullscreen == false)
            {
                self.hideControlsAnimated(true)
            }
            
            self.syncFullScreenButton(UIApplication.sharedApplication().statusBarOrientation)
            
            
            if(self.fullscreenViewController == nil)
            {
                self.fullscreenViewController = FullScreenViewController()
                self.fullscreenViewController?.allowPortraitFullscreen = self.allowPortratiFullScreen
                
            }
            
            self.videoPlayerView?.setFullscreen(true)
            
            self.fullscreenViewController?.view.addSubview(self.videoPlayerView!)
            
            if(self.topView != nil)
            {
                self.topView?.removeFromSuperview()
                self.fullscreenViewController?.view.addSubview(self.topView!)
            }
            
            if(self.isAlwaysFullscreen == true)
            {
                self.videoPlayerView?.alpha = 0
            }
            else
            {
                self.previousBounds = self.videoPlayerView?.frame
                
                UIView.animateWithDuration(0.45, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    
                    self.videoPlayerView?.center = CGPointMake( self.videoPlayerView!.superview!.bounds.size.width / 2, ( self.videoPlayerView!.superview!.bounds.size.height / 2))
                    self.videoPlayerView?.bounds = self.videoPlayerView!.superview!.bounds;
                    
                    }, completion: nil)
            }
            
            
            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(self.fullscreenViewController!, animated: true, completion: { () -> Void in
                
                if(self.isAlwaysFullscreen == true)
                {
                    self.videoPlayerView?.frame = CGRectMake(self.videoPlayerView!.superview!.bounds.size.width / 2, self.videoPlayerView!.superview!.bounds.size.height / 2, 0, 0)
                    
                    self.previousBounds = CGRectMake(self.videoPlayerView!.superview!.bounds.size.width / 2, self.videoPlayerView!.superview!.bounds.size.height / 2, 0, 0)
                    
                    self.videoPlayerView?.center = CGPointMake( self.videoPlayerView!.superview!.bounds.size.width / 2, self.videoPlayerView!.superview!.bounds.size.height / 2)
                    
                    
                    UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        
                        self.videoPlayerView?.alpha = 1
                        
                    }, completion: nil)
                    
                    self.videoPlayerView?.frame = (self.videoPlayerView?.superview?.bounds)!
                }
                
                if(self.topView != nil)
                {
                    self.topView?.frame = CGRectMake(0, 0, self.videoPlayerView!.frame.size.width, self.topView!.frame.size.height)
                    
                }
                
            
//                if(self.delegate.res)
//                {
//                    
//                }
            })
            
        }
    }
    func syncFullScreenButton(toInterfaceOrientation:UIInterfaceOrientation)
    {
        
        if(self.fullScreenModeToggled == true)
        {
            self.videoPlayerView?.fullScreenButton?.setImage(UIImage(named: "minimize-button.png"), forState: UIControlState.Normal)
            
        }
        else
        {
            self.videoPlayerView?.fullScreenButton?.setImage(UIImage(named: "fullscreen-button.png"), forState: UIControlState.Normal)
        }
    }
    
    func minimizeVideo()
    {
        
        if(self.fullScreenModeToggled == true)
        {
            self.fullScreenModeToggled = false
            self.videoPlayerView?.setFullscreen(false)
            self.hideControlsAnimated(false)
            self.syncFullScreenButton(self.interfaceOrientation)
            
            if(self.topView != nil)
            {
                if(self.containingView != nil)
                {
                    self.containingView?.addSubview(self.topView!)
                }
                else
                {
                    self.containingViewController?.view.addSubview(self.topView!)
                }
                
            }
            
            if(self.isAlwaysFullscreen == true)
            {
                UIView.animateWithDuration(0.45, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.videoPlayerView?.frame = self.previousBounds!
                    }, completion: { (success:Bool) -> Void in
                        
                        if(self.showShareOptions == true)
                        {
                            self.presentShareOptions()
                        }
                        
                        self.videoPlayerView?.removeFromSuperview()
                })
            }
            else
            {
                UIView.animateWithDuration(0.45, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.videoPlayerView?.frame = self.previousBounds!
                    }, completion: { (success:Bool) -> Void in
                        
                        if(self.showShareOptions == true)
                        {
                            self.presentShareOptions()
                        }
                        
                })
                
                self.videoPlayerView?.removeFromSuperview()
                
                if(self.containingView != nil)
                {
                    self.containingView?.addSubview(self.videoPlayerView!)
                }
                else
                {
                    self.containingViewController?.view.addSubview(self.videoPlayerView!)
                }
            }
            
            ////////
//            UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(self.isAlwaysFullscreen!, completion: { () -> Void in
//                
//                
//                if(self.isAlwaysFullscreen == false)
//                {
//                    self.showControls()
//                }
//                
//                UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
//            })
            
//            let delegate:AppDelegate = UIApplication.sharedApplication().delegate
            UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                if(self.isAlwaysFullscreen == false)
                {
                    self.showControls()
                }
                
                
            })
        }

        
    }
    
    func pause()
    {
        
        if(self.seekToZeroBeforePlay == true)
        {
            
            self.seekToZeroBeforePlay = false
            self.videoPlayer?.seekToTime(kCMTimeZero)
        }
        
        if(self.isPlaying() == true)
        {
            self.videoPlayer?.pause()
        }
        
        self.syncPlayPauseButtons()
        self.showControls()
        
    }
    
    // Wait for the video player status to change to ready before initializing video player controls

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if(object as? NSObject == self.videoPlayer && (keyPath == "externalPlaybackActive" || keyPath == "airPlayVideoActive"))
        {
            let externalPlaybackActive:Bool = (object!.objectForKey("NSKeyValueChangeNewKey")?.boolValue)!
            self.videoPlayerView?.airplayIsActiveView?.hidden = externalPlaybackActive
            
            return
        }
        
        if(object as? AVPlayerItem != self.videoPlayer?.currentItem)
        {
            return
        }
        
        if(keyPath == "status")
        {
            
            let statusObj:AVPlayerItem = object! as! AVPlayerItem
//            let status:AVPlayerStatus = statusObj.objectForKey("object") as! AVPlayerStatus
            
            let status:AVPlayerItemStatus = statusObj.status
            
            
            switch(status)
            {
                case AVPlayerItemStatus.ReadyToPlay:
                    
                    self.playWhenReady = true
                    
                    self.pause()
                    
                    self.playVideo()
                    
                    break;
                case AVPlayerItemStatus.Failed:
                    
                    self.removeObserversFromVideoPlayerItem()
                    self.removePlayerTimeObservers()
                    self.videoPlayer = nil
                    
                    break;
            default:
                break;
            }
        }
        else if(keyPath == "playbackBufferEmpty" && self.videoPlayer?.currentItem?.playbackBufferEmpty == true)
        {
            self.playerIsBuffering = true
            self.videoPlayerView?.activityIndicator?.startAnimating()
            self.syncPlayPauseButtons()
        }
        else if(keyPath == "playbackLikelyToKeepUp" && self.videoPlayer?.currentItem?.playbackLikelyToKeepUp == true)
        {
            
            if(self.isPlaying() == true && (self.playWhenReady == true || self.playerIsBuffering == true || scrubBuffering == true) && self.autoPlay == true)
            {
                self.playVideo()
            }
            self.videoPlayerView?.activityIndicator?.stopAnimating()
        }
        else if(keyPath == "loadedTimeRanges")
        {
            let durationTime:Float = Float(CMTimeGetSeconds((self.videoPlayer?.currentItem?.duration)!))
            let bufferTime:Float = self.availableDuration()
            
            
            self.videoPlayerView?.progressView?.progress = bufferTime / durationTime
        }
        
        return
        
    }
    func availableDuration() -> Float
    {
        let loadedTimeRanges:NSArray = (self.videoPlayer?.currentItem?.loadedTimeRanges)!
        
        if(loadedTimeRanges.count > 0)
        {
            
            let timeRange:CMTimeRange = loadedTimeRanges.objectAtIndex(0).CMTimeRangeValue
            let startSeconds:Float = Float(CMTimeGetSeconds(timeRange.start))
            let durationSeconds:Float = Float(CMTimeGetSeconds(timeRange.duration))
            return (startSeconds + durationSeconds)
        }
        else
        {
            return 0
        }
    }
    func removePlayerTimeObservers()
    {
        if(self.scrubberTimeObserver != nil)
        {
            self.videoPlayer?.removeTimeObserver(self.scrubberTimeObserver!)
            self.scrubberTimeObserver = nil
        }
        
        if(self.playClockTimeObserver != nil)
        {
            self.videoPlayer?.removeTimeObserver(self.playClockTimeObserver!)
            self.playClockTimeObserver = nil
        }
    }
    

}
