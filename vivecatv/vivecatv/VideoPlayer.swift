//
//  VideoPlayer.swift
//  vivecatv
//
//  Created by Solar Jang on 9/21/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import Foundation

let kVideoPlayerVideoChangedNotification = "kVideoPlayerVideoChangedNotification"
let kVideoPlayerWillHideControlsNotification = "kVideoPlayerWillHideControlsNotification"
let kVideoPlayerWillShowControlsNotification = "kVideoPlayerWillShowControlsNotification"
let kTrackEventVideoStart = "kTrackEventVideoStart"
let kTrackEventVideoLiveStart = "kTrackEventVideoLiveStart"
let kTrackEventVideoComplete = "kTrackEventVideoComplete"

protocol VideoPlayerDelegate
{
    func trackEvent(event:String, videoID:String, title:String)
    
}

extension VideoPlayerDelegate{
    
    
    func trackEvent(event:String, videoID:String, title:String)
    {
        
    }
}

protocol VideoPlayer
{
    func playVideoWithTitle(title:String, url:NSURL, videoID:String?, shareURL:String?, streaming:Bool, playInFullScreen:Bool)
    func showCannotFetchStreamError()
    func launchFullScreen()
    func minimizeVideo()
    func playPauseHandler()
    
}
//extension VideoPlayer{
//    
//    func playVideoWithTitle(title:String, url:NSURL, videoID:String?, shareURL:String?, streaming:Bool, playInFullScreen:Bool)
//    {
//        
//    }
//    func showCannotFetchStreamError()
//    {
//        
//    }
//    func launchFullScreen()
//    {
//        
//    }
//    func minimizeVideo()
//    {
//        
//    }
//    func playPauseHandler()
//    {
//        
//    }
//}

