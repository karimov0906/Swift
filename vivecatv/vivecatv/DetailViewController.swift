//
//  DetailViewController.swift
//  vivecatv
//
//  Created by Solar Jang on 9/19/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit
import MediaPlayer


class DetailViewController: UIViewController, UISplitViewControllerDelegate, DetailViewDelegate, VideoPlayerDelegate {
    
    var masterDelegate:MasterViewControllerDelegate?
    var detailView:DetailView?
    
    var detailItem:AnyObject?
    @IBOutlet var detailDescriptionLabel:UILabel?

    
    var timeMachingSongTitle:String?
    var currentYouTubeVideoLink:String?
    var musicPlayerController:MPMusicPlayerController?
    var twitterUserName:String?
    var songDetailsAlt:AnyObject?
    
    var linkAlt:String?
    
    var videoPlayerViewController:VideoPlayerKit?
    var videoPlayerAlt:VideoPlayerKit?
//    var masterPopoverController:UIPopoverController?
    
    var videoDurationAlt:Double?
    var videoDuration:Double?
    
    var isAltInitialized:Bool?
    var isBuffering:Bool?
    
    var timer:NSTimer?
    
    
    var adcontroller:AdvertiseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clearColor()
        
        
        self.view.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        
        let localDetailView = DetailView(frame: CGRectMake(0, 0, 703, 724))
        localDetailView.delegate = self
        localDetailView.tag = 4000
        
        self.detailView = localDetailView
        self.view = self.detailView
        
        self.configureView()
    }
    
    func configureView()
    {
        if((self.detailItem) != nil)
        {
            self.detailDescriptionLabel?.text = self.detailItem?.description
        }
    }
    
    func getTweet()
    {
        self.sendRequestToTwitterWithUserName("@playviveca")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendRequestToTwitterWithUserName(userName:String)
    {
        
    }
    func youTubVideoDidSelectedInMasterListWithLink(link:String, userName:String, artistName:String, details:AnyObject)
    {
        self.youTubVideoDidSelectedInMasterListWithLink(link, userName: userName, artistName: artistName, details: details, alt: false)
    }
    func showMetaData()
    {
        var music:MusicList?
        var video:VideoList?
        var imageData:NSData?
        
        if((self.songDetailsAlt?.isKindOfClass(MusicList)) != nil)
        {
            music = self.songDetailsAlt as? MusicList
            
            
            self.timeMachingSongTitle = music?.title
            self.detailView?.lblInfo?.text = music?.title
            self.detailView?.txtViewLyrics?.text = music?.info
            
            imageData = NSData(contentsOfURL: (music?.infoUrl)!)!
        }
        if((self.songDetailsAlt?.isKindOfClass(VideoList)) != nil)
        {
            video = self.songDetailsAlt as? VideoList
            
            
            self.timeMachingSongTitle = video?.title
            self.detailView?.lblInfo?.text = video?.title
            self.detailView?.txtViewLyrics?.text = video?.info
            
            imageData = NSData(contentsOfURL: (video?.infoUrl)!)!
        }
        
        self.detailView?.imgViewInfo?.image = UIImage(data: imageData!)
        self.currentYouTubeVideoLink = self.linkAlt
        
    }
    func youTubVideoDidSelectedInMasterListWithLink(link:String, userName:String, artistName:String, details:AnyObject, alt:Bool)
    {
        var range:NSRange = NSMakeRange(0, 0)
        
        if((songDetailsAlt?.isKindOfClass(MusicList)) == true)
        {
            let music:MusicList = (songDetailsAlt as? MusicList)!
            
            if(alt == false)
            {
                self.timeMachingSongTitle = music.title
                self.detailView?.lblInfo?.text = music.title
                self.detailView?.txtViewLyrics?.text = music.info
            }
            
            let componetsIn:NSArray = (music.iN?.componentsSeparatedByString(":"))!
            
            var inTime:NSInteger = 0
            
            if(componetsIn.count > 2)
            {
                var hrs:NSInteger = componetsIn[0].integerValue
                hrs = hrs * 3600
                var mins:NSInteger = componetsIn[1].integerValue
                mins = mins * 60
                let seconds:NSInteger = componetsIn[2].integerValue
                inTime = hrs + mins + seconds
            }
            
            let componetsAux:NSArray = (music.aux?.componentsSeparatedByString(":"))!
            
            var outTime:NSInteger = 0
            
            if(componetsAux.count > 2)
            {
                var hrs:NSInteger = componetsAux[0].integerValue
                hrs = hrs * 3600
                var mins:NSInteger = componetsAux[1].integerValue
                mins = mins * 60
                
                let seconds:NSInteger = componetsAux[2].integerValue
                
                outTime = hrs + mins + seconds
                
            }
            
            range = NSMakeRange(inTime, outTime)
            
            if(alt == false)
            {
                let imageData:NSData = NSData(contentsOfURL: music.infoUrl!)!
                self.detailView?.imgViewInfo?.image = UIImage(data: imageData)
            }
            
        }
        else if((songDetailsAlt?.isKindOfClass(VideoList)) == true)
        {
            let video:VideoList = (songDetailsAlt as? VideoList)!
            
            if(alt == false)
            {
                self.timeMachingSongTitle = video.title
                self.detailView?.lblInfo?.text = video.title
                self.detailView?.txtViewLyrics?.text = video.info
            }
            
            let componetsIn:NSArray = (video.iN?.componentsSeparatedByString(":"))!
            
            var inTime:NSInteger = 0
            
            if(componetsIn.count > 2)
            {
                var hrs:NSInteger = componetsIn[0].integerValue
                hrs = hrs * 3600
                var mins:NSInteger = componetsIn[1].integerValue
                mins = mins * 60
                let seconds:NSInteger = componetsIn[2].integerValue
                inTime = hrs + mins + seconds
            }
            
            let componetsAux:NSArray = (video.aux?.componentsSeparatedByString(":"))!
            
            var outTime:NSInteger = 0
            
            if(componetsAux.count > 2)
            {
                var hrs:NSInteger = componetsAux[0].integerValue
                hrs = hrs * 3600
                var mins:NSInteger = componetsAux[1].integerValue
                mins = mins * 60
                
                let seconds:NSInteger = componetsAux[2].integerValue
                
                outTime = hrs + mins + seconds
                
            }
            
            range = NSMakeRange(inTime, outTime)
            
            if(alt == false)
            {
                let imageData:NSData = NSData(contentsOfURL: video.infoUrl!)!
                self.detailView?.imgViewInfo?.image = UIImage(data: imageData)
            }

        }
        
        if(alt == false)
        {
            self.currentYouTubeVideoLink = link
        }
        
        self.linkAlt = link
        self.songDetailsAlt = details
        
        self.playYouTubeVideo(range, alt: alt)
        
    }
    func setTwitterDetailWithStatus(statusDictionary:NSDictionary)
    {
        
    }
    func resetTimer()
    {
        self.isBuffering = false
        
        if(self.timer != nil)
        {
            self.timer?.invalidate()
            self.timer = nil
        }
        
    }
    func embedYouTube(urlString:NSString, tag:Int, frame:CGRect, playbackRange:NSRange, alt:Bool)
    {
        let url:NSURL = NSURL(string: urlString as String)!
        
        if(alt == false)
        {
            if(self.videoPlayerViewController == nil)
            {
                self.videoPlayerViewController = VideoPlayerKit().videoPlayerWithContainingViewController(self, topView: nil, hideTopViewWithControls: true)
                self.videoPlayerViewController?.delegate = self
                self.videoPlayerViewController?.autoPlay = true
                self.videoPlayerViewController?.allowPortratiFullScreen = true
                
                self.videoPlayerViewController?.view.backgroundColor = UIColor.blackColor()
                self.videoPlayerViewController?.view.frame = frame
                self.videoPlayerViewController?.containingView = self.detailView?.secondDetailView
                self.detailView?.secondDetailView?.addSubview((self.videoPlayerViewController?.view!)!)
                
//                self.detailView?.secondDetailView?.backgroundColor = UIColor.redColor()
                
            }
            
            self.videoPlayerViewController?.playVideoWithTitle("", url: url, videoID: nil, shareURL: nil, streaming: false, playInFullScreen: false)
//            self.videoPlayerViewController?.playVideoWithTitle(<#T##title: String##String#>, url: <#T##NSURL#>, videoID: <#T##String?#>, shareURL: <#T##String?#>, streaming: <#T##Bool#>, playInFullScreen: <#T##Bool#>)
//            self.videoPlayerViewController?.videoPlayer?.seekToTime(CMTimeMakeWithSeconds(Float64(playbackRange.location), Int32(NSEC_PER_SEC)))
       
            self.videoDuration = Double(playbackRange.length)
            
            self.resetTimer()
            
            if(self.timer == nil)
            {
                self.timer = NSTimer(timeInterval: 0.5, target: self, selector: Selector("videoWillFinishLoading"), userInfo: nil, repeats: true)
            }
            
            self.isAltInitialized = false
            
            
        }
        else
        {
            
            self.videoPlayerAlt = VideoPlayerKit().videoPlayerWithContainingViewController(self, topView: nil, hideTopViewWithControls: true)
            self.videoPlayerAlt?.delegate = self
            self.videoPlayerAlt?.autoPlay = true
            self.videoPlayerAlt?.allowPortratiFullScreen = true
            
            self.videoPlayerAlt?.view.backgroundColor = UIColor.blackColor()
            self.videoPlayerAlt?.view.frame = frame
            self.videoPlayerAlt?.view.hidden = true
            
            self.videoPlayerAlt?.videoPlayer?.muted = true
            
            self.videoPlayerAlt?.containingView = self.detailView?.secondDetailView
            
            self.detailView?.secondDetailView?.addSubview((self.videoPlayerAlt?.view!)!)
            self.view.bringSubviewToFront((self.videoPlayerAlt?.view)!)
            
            
            self.videoPlayerAlt?.playVideoWithTitle("", url: url, videoID: nil, shareURL: nil, streaming: false, playInFullScreen: false)
            self.videoDurationAlt = Double(playbackRange.length)
            
            self.videoPlayerAlt?.videoPlayer?.seekToTime(CMTimeMakeWithSeconds(Float64(playbackRange.location), Int32(NSEC_PER_SEC)))
            
            self.isAltInitialized = true
        }
    }
    func videoWillFinishLoading()
    {
        let currentPlayedTime:Double = CMTimeGetSeconds((self.videoPlayerViewController?.videoPlayer?.currentTime())!)
        
        if(currentPlayedTime >= (self.videoDuration! > 40 ? self.videoDuration! - 30 : self.videoDuration! * 0.8) && self.isAltInitialized == false)
        {
            self.masterDelegate?.nextButtonDidTouchedCallback()
        }
        
        if(currentPlayedTime >= self.videoDuration! && self.timer != nil)
        {
            self.resetTimer()
            self.playNextVideo()
        }
    }
    func playNextVideo()
    {
        self.resetTimer()
        
        if(self.videoPlayerAlt != nil)
        {
            self.videoPlayerAlt?.view.frame = (self.videoPlayerViewController?.view.frame)!
            self.videoPlayerViewController?.view.removeFromSuperview()
            
            self.videoPlayerViewController = self.videoPlayerAlt
            
            self.videoPlayerViewController?.playPauseHandler()
            
            self.view.bringSubviewToFront((self.videoPlayerViewController?.view)!)
            
            self.videoPlayerViewController?.autoPlay = true
            self.videoPlayerViewController!.view.hidden = false
            
            self.videoPlayerViewController?.videoPlayer?.muted = false
            
            self.videoDuration = videoDurationAlt
            
            if(self.timer == nil)
            {
                self.timer = NSTimer(timeInterval: 0.5, target: self, selector: Selector("videoWillFinishLoading"), userInfo: nil, repeats: true)
            }
            
            self.showMetaData()
            self.masterDelegate!.updateValues()
            
            self.videoPlayerAlt = nil
            self.isAltInitialized = false
        }
        else
        {
            self.masterDelegate?.nextButtonDidTouchedCallback()
        }
    }
    
    func trackEvent(event: String, videoID: String, title: String) {
        
        print(event)
        print(videoID)
        print(title)
        
        if(event == "Video Complete")
        {
            self.playNextVideo()
        }
        
        
    }
    
    func playYouTubeVideo(playBackRange:NSRange, alt:Bool)
    {
        let youtubePlayerRect:CGRect?
        
        if(alt == true)
        {
            youtubePlayerRect = CGRectMake(20, 350, 662, 310)
            
            self.embedYouTube(self.linkAlt!, tag: 100, frame: youtubePlayerRect!, playbackRange: playBackRange, alt: alt)
        }
        else
        {
            youtubePlayerRect = CGRectMake(20, 19, 662, 310)
            
            self.embedYouTube(self.currentYouTubeVideoLink!, tag: 100, frame: youtubePlayerRect!, playbackRange: playBackRange, alt: alt)
        }
        
        
        
    }
    func getTimeWithCreatedTime(createdTime:NSDate)
    {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func nextButtonDidSelected()
    {
//        let musicPlayer:MPMusicPlayerController = MPMusicPlayerController.applicationMusicPlayer()
        
        var anyVC: AnyObject?
//        var storyBoard: UIStoryboard?
//        storyBoard = UIStoryboard(name:"MainStoryboard", bundle: nil)
        
        anyVC = storyboard?.instantiateViewControllerWithIdentifier("adController")
        
        self.adcontroller = anyVC as? AdvertiseViewController
        
        self.presentViewController(self.adcontroller!, animated: true) { () -> Void in
            
            self.adcontroller?.detailDelegate = self
        }
    }
    func onlyButtonDidSelectedWithVivecaSearch(vivecaSearch:Search)
    {
        
    }
    func similarButtonDidSelectedWithVivecaSearch(vivecaSearch:Search)
    {
        
    }
    func videoCategoryDidSelectedWithTitle(title:String)
    {
        
    }
    func twitterShareButtonClicked()
    {
        
    }
    func searchTextRemovedCallback(query:String)
    {
        self.masterDelegate?.searchTextRemovedCallback(query)
    }
    func timeMachineDidSelectedWithTitle(title:String)
    {
        self.masterDelegate?.timeMachineDidSelectedCallbackWithTitle1(title)
    }
}

protocol MasterViewControllerDelegate{
    
    func timeMachineDidSelectedCallbackWithTitle1(title:String)
    func videoCategoryDidSelectedCallbackWithTitle(title:String)
    func onlyButtonDidSelectedCallbackWithVivecaSearch(vivecaSearch:Search)
    func similarButtonDidSelectedCallbackWithVivecaSearch(vivecaSearch:Search)
    func nextButtonDidTouchedCallback()
    func searchTextRemovedCallback(searchParam:String)
    func updateValues()
}

//extension MasterViewControllerDelegate
//{
//    func timeMachineDidSelectedCallbackWithTitle(title:String)
//    {
//    }
//    func videoCategoryDidSelectedCallbackWithTitle(title:String)
//    {
//    
//    }
//    func onlyButtonDidSelectedCallbackWithVivecaSearch(vivecaSearch:Search)
//    {
//    
//    }
//    func similarButtonDidSelectedCallbackWithVivecaSearch(vivecaSearch:Search)
//    {
//        
//    }
//    func nextButtonDidTouchedCallback()
//    {
//        
//    }
//    func searchTextRemovedCallback(searchParam:String)
//    {
//        
//    }
//}