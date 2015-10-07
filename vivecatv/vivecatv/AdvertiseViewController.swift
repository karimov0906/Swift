//
//  AdvertiseViewController.swift
//  vivecatv
//
//  Created by Solar Jang on 9/19/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class AdvertiseViewController: UIViewController, WebserviceManagerDelegate {
    
    var detailDelegate:DetailViewController?
    @IBOutlet var imgViewTile:UIImageView?
    
//    var moviePlayer:MPMoviePlayerController?
    var moviePlayer1:AVPlayerViewController?
    @IBOutlet var bgImageView:UIImageView?
    @IBOutlet var closeButton:UIButton?
    var appDelegate:AppDelegate?
    
    let player = AVPlayer()

    
    @IBOutlet var videoPlayerView:PlayerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imgViewTile?.layer.borderColor = UIColor(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0, alpha: 1).CGColor
        self.imgViewTile?.layer.borderWidth = 1
        
//        let localMPMoviePlayerController:MPMoviePlayerController = MPMoviePlayerController()
//        self.moviePlayer = localMPMoviePlayerController
        
        self.moviePlayer1 = AVPlayerViewController()
        
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if(appDelegate?.adsArray.count < 1)
        {
            let manager:WebserviceManager = WebserviceManager()
            manager.delegate = self
            
            manager.getAdvertisement()
        }
        else
        {
            self.loadAdvertise()
        }
    }
    
    @IBAction func closeAction()
    {
        self.videoPlayerView?.playerLayer.player?.pause()

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadVideo(url:NSURL)
    {
        /*
        self.moviePlayer?.movieSourceType = MPMovieSourceType.Streaming
        self.moviePlayer?.contentURL = url
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("moviePlaybackComplete:"), name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayer!)
        
        
        let youtubePlayerRect:CGRect = CGRectMake(192, 235, 640, 295)
        self.moviePlayer?.view.frame = youtubePlayerRect
        self.moviePlayer?.controlStyle = MPMovieControlStyle.Default
        
        self.moviePlayer?.play()
        
        self.view.addSubview((self.moviePlayer?.view)!)
        */
        
//        let player:AVPlayer = AVPlayer(URL: url)
//        self.moviePlayer1?.player = player
//        let playerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = CGRectMake(192, 235, 640, 295)
//        
//        self.bgImageView!.layer.addSublayer(playerLayer)
//        player.play()
        
        let playerItem:AVPlayerItem = AVPlayerItem(URL: url)
        self.player.replaceCurrentItemWithPlayerItem(playerItem)
        self.videoPlayerView?.playerLayer.player = self.player
        
        self.videoPlayerView?.playerLayer.player?.play()
        
    }
    func diFailwebservice() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func didDownloadAdvertisementList(advertisementList: NSDictionary) {
        
        
        let error:NSDictionary = advertisementList["error"] as! NSDictionary
        
        if(error["code"]?.integerValue == 200)
        {
            let resultDic:NSDictionary = advertisementList["result"] as! NSDictionary
            let adverList:NSArray = resultDic["Advertisement"] as! NSArray
            
            for(var i:Int=0; i < adverList.count; i++)
            {
                let adverDic:NSDictionary = adverList[i] as! NSDictionary
                
                let obj:adVertisement = adVertisement()
                
                obj.bgimgurl = NSURL(string: (adverDic["bgimgurl"] as? String)!)
                obj.title = adverDic["title"] as? String
                obj.iN = adverDic["In"] as? String
                obj.logourl = NSURL(string: (adverDic["logourl"] as? String)!)
                obj.position = adverDic["position"] as? String
                obj.aux = adverDic["Aux"] as? String
                obj.adurl = NSURL(string: (adverDic["adurl"] as? String)!)
                
                self.appDelegate?.adsArray.addObject(obj)
                
                
            }
        }
        
        self.loadAdvertise()
        
    }
    func GetMusicVideosByYearHandler(musicList:NSDictionary)
    {
        
    }
    func GetEntertainmentVideosByYearHandler(entertainmentList:NSDictionary)
    {
        
    }
    func GetYearListHandler(yearList:NSDictionary)
    {
        
    }

    
    
    
    func loadAdvertise()
    {
        if(self.appDelegate?.adsArray.count > 0)
        {
            
            let ads:adVertisement = appDelegate?.adsArray[0] as! adVertisement

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                
                print(ads.bgimgurl!)
                let imageData:NSData = NSData(contentsOfURL: ads.bgimgurl!)!

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.bgImageView?.image = UIImage(data: imageData)
                })
            })
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                
                let titleData:NSData = NSData(contentsOfURL: ads.logourl!)!
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.imgViewTile?.image = UIImage(data:titleData)
                })
            })
            
            
            
            
            self.loadVideo(ads.adurl!)
        }
    }
    
    func moviePlaybackComplete(notification:NSNotification)
    {
//        var moviePlayerController:MPMoviePlayerController? = notification.object as? MPMoviePlayerController
//        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayerController)
//        
//        moviePlayerController!.view.removeFromSuperview()
//        moviePlayerController = nil
        
    }
    
    func dismissAdvertise()
    {
        self.videoPlayerView?.playerLayer.player?.pause()

        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
