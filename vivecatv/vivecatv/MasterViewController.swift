//
//  MasterViewController.swift
//  vivecatv
//
//  Created by Solar Jang on 9/19/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, WebserviceManagerDelegate, MasterViewControllerDelegate {

    
    var masterListArray:NSMutableArray = NSMutableArray()
    var masterPlayListTableView:UITableView?
    var currentSelection:String?
    
    var currentSelectedMusicRowIndex:Int = -1
    var currentSelectedMusicRowIndexAlt:Int = -1
    var currentSelectedEntertainRowIndex :Int = -1
    var currentSelectedEntertainRowIndexAlt:Int = -1
    var previousSelectedMusicRowIndex:Int = -1
    var previousSelectedEntertainRowIndex:Int = -1
    
    var isEntertainmentSelected:Bool = false
    var isTimeMachineVideoCategorySelected:Bool = false
    var isVideoCategorySelected:Bool = false
    var isOnlyButtonSelected:Bool = false
    var isMusicSegmentSelected:Bool = false
    
    var masterCell:MasterListCell?
    var entertainmentArray:NSMutableArray = NSMutableArray()
    
    var isSelectedFromDidSelect:Bool = false
    var isSelectedFromEntertainment:Bool = false
    var isSelectedFromMusic:Bool = false
    var isSelectedFromMusicAlt:Bool = false
    
    var detailViewController:DetailViewController?
    var musicEntertainSegmentControl:UISegmentedControl?
    
    var btnMusic:UIButton?
    var btnEntertainment:UIButton?
    
    var masterMusicArray:NSMutableArray = NSMutableArray()
    var masterEntertainmentArray:NSMutableArray = NSMutableArray()
    
    // MARK ; functions
    func addMasterListTableOnVew()
    {
        
        let localMasterPlayListTableView:UITableView = UITableView(frame: CGRectMake(0, 50, 320, 716), style: UITableViewStyle.Plain)
        localMasterPlayListTableView.delegate = self
        localMasterPlayListTableView.dataSource = self
        localMasterPlayListTableView.rowHeight = 44
        localMasterPlayListTableView.sectionHeaderHeight = 20
        localMasterPlayListTableView.backgroundColor = UIColor.clearColor()
        localMasterPlayListTableView.showsHorizontalScrollIndicator = false
        localMasterPlayListTableView.separatorColor = UIColor(patternImage: UIImage(named: "ListSeperatorColor.png")!)
        self.masterPlayListTableView = localMasterPlayListTableView

        self.view.addSubview(self.masterPlayListTableView!)
        
        
        self.masterPlayListTableView?.registerNib(UINib(nibName: "MasterListCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
        
    }
    func addFaceBookAndTweeterButtonOnView(frame:CGRect, buttonImage:String)
    {
        
        let localButton:UIButton = UIButton(type: UIButtonType.Custom)
        localButton.frame = frame
        localButton.setImage(UIImage(named: buttonImage), forState: UIControlState.Normal)
        self.view.addSubview(localButton)
        
    }
    func loadYouTubeVideoInDetailView()
    {
        var currentIndex:Int = 0
        
        if(self.isMusicSegmentSelected == true)
        {
            currentIndex  = self.currentSelectedMusicRowIndex
            
            if(self.masterListArray.count != 0)
            {
                
                if(self.isTimeMachineVideoCategorySelected == true)
                {
                    let object:AnyObject = self.masterListArray.objectAtIndex(currentIndex)
                    
                    if(object.isKindOfClass(MusicList) == true)
                    {
                        let timeMachine:MusicList = object as! MusicList
                        
                        self.detailViewController?.youTubVideoDidSelectedInMasterListWithLink((timeMachine.musicurl?.absoluteString)!, userName: "@playviveca", artistName: "", details: object)
                    }
                    else{
                        return
                    }
                }
                else
                {
                    let object:AnyObject = self.masterListArray.objectAtIndex(currentIndex)
                    
                    if(object.isKindOfClass(MusicList) == true)
                    {
                        let timeMachine:MusicList = object as! MusicList
                        
                        self.detailViewController?.youTubVideoDidSelectedInMasterListWithLink((timeMachine.musicurl?.absoluteString)!, userName: "test", artistName: "", details: object)
                    }
                    else{
                        return
                    }

                }
            }
        }
        else
        {
            currentIndex = self.currentSelectedEntertainRowIndex
            
            if(self.entertainmentArray.count != 0)
            {
                if(self.isTimeMachineVideoCategorySelected == true)
                {
                    let object:AnyObject = self.entertainmentArray.objectAtIndex(currentIndex)
                    
                    if(object.isKindOfClass(VideoList) == true)
                    {
                        let timeMachine:VideoList = object as! VideoList
                        
                        self.detailViewController?.youTubVideoDidSelectedInMasterListWithLink((timeMachine.enturl?.absoluteString)!, userName: "@playviveca", artistName: "", details: object)
                    }
                    else{
                        return
                    }
                }
                else
                {
                    let object:AnyObject = self.entertainmentArray.objectAtIndex(currentIndex)
                    
                    if(object.isKindOfClass(VideoList) == true)
                    {
                        let timeMachine:VideoList = object as! VideoList
                        
                        self.detailViewController?.youTubVideoDidSelectedInMasterListWithLink((timeMachine.enturl?.absoluteString)!, userName: "", artistName: "", details: object)
                    }
                    else{
                        return
                    }
                    
                }

            }
        }
    }
    func loadYouTubeVideoInDetailView(isMusicSegmentSelectedAlt:Bool, currentMusicRowIndexAlt:Int,currentEntertainRowIndexAlt:Int )
    {
        self.isSelectedFromMusicAlt = isMusicSegmentSelectedAlt
        self.currentSelectedEntertainRowIndexAlt = currentEntertainRowIndexAlt
        self.currentSelectedMusicRowIndexAlt = currentMusicRowIndexAlt
        
        var currentIndex:Int = 0
        
        if(isMusicSegmentSelectedAlt == true)
        {
            currentIndex = currentSelectedMusicRowIndexAlt
            if(self.masterListArray.count != 0)
            {
                let obj:AnyObject = self.masterListArray.objectAtIndex(0)

                if(self.isTimeMachineVideoCategorySelected == true)
                {
                    
                    if(obj.isKindOfClass(MusicList))
                    {
                        let timeMachine:MusicList = self.masterListArray.objectAtIndex(currentIndex) as! MusicList
                        self.detailViewController?.youTubVideoDidSelectedInMasterListWithLink((timeMachine.musicurl?.absoluteString)!, userName: "@playviveca", artistName: "", details: timeMachine, alt: true)
                        
                    }
                    else
                    {
                        return
                    }
                }
                else
                {
                    if(obj.isKindOfClass(MusicList))
                    {
                        let timeMachine:MusicList = self.masterListArray.objectAtIndex(currentIndex) as! MusicList
                        self.detailViewController?.youTubVideoDidSelectedInMasterListWithLink((timeMachine.musicurl?.absoluteString)!, userName: "test", artistName: "", details: timeMachine, alt: true)

                    }
                    else
                    {
                        return
                    }
                }
            }
        }
        else
        {
            currentIndex = self.currentSelectedEntertainRowIndexAlt
            if(self.entertainmentArray.count != 0)
            {
                
                let obj:AnyObject = self.masterListArray.objectAtIndex(0)

                if(isTimeMachineVideoCategorySelected == true)
                {
                    
                    if(obj.isKindOfClass(VideoList))
                    {
                        let timeMachine:VideoList = self.entertainmentArray.objectAtIndex(currentIndex) as! VideoList
                        
                        self.detailViewController?.youTubVideoDidSelectedInMasterListWithLink((timeMachine.enturl?.absoluteString)!, userName: "@playviveca", artistName: "", details: timeMachine, alt: true)
                    }
                }
                else
                {
                    
                    if(obj.isKindOfClass(VideoList))
                    {
                        let timeMachine:VideoList = self.entertainmentArray.objectAtIndex(currentIndex) as! VideoList
                        
                        self.detailViewController?.youTubVideoDidSelectedInMasterListWithLink((timeMachine.enturl?.absoluteString)!, userName: "", artistName: "", details: timeMachine, alt: true)
                    }
                }
            }
        }
    }
    func updateValues()
    {
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let playedEntertainMentYouTubeVideos:Int = userDefaults.integerForKey("PlayedEntertainMentYouTubeVideos")
        let allowedEntertainMentYouTubeVideos:Int = userDefaults.integerForKey("AllowedEntertainMentYouTubeVideos")
        
        let playedMusicYouTubeVideos:Int = userDefaults.integerForKey("PlayedMusicYouTubeVideos")
        let allowedMusicYouTubeVideos:Int = userDefaults.integerForKey("AllowedMusicYouTubeVideos")
        
        if(self.isSelectedFromMusicAlt)
        {
            self.isSelectedFromMusic = isSelectedFromMusicAlt
            self.currentSelectedMusicRowIndex = currentSelectedMusicRowIndexAlt
            
            var idx:Int = 0
            
            if(playedMusicYouTubeVideos <= allowedMusicYouTubeVideos)
            {
                idx = playedMusicYouTubeVideos + 1
            }
            else
            {
                idx = 1
            }
            
            userDefaults.setInteger(idx, forKey: "PlayedMusicYouTubeVideos")
            
            self.switchToSelectedControl(0)
        }
        else
        {
            self.isSelectedFromEntertainment = true
            self.currentSelectedEntertainRowIndex = currentSelectedEntertainRowIndexAlt
            
            var idx:Int = 0
            
            if(playedEntertainMentYouTubeVideos <= allowedEntertainMentYouTubeVideos)
            {
                idx = playedEntertainMentYouTubeVideos + 1
            }
            else
            {
                idx = 1
            }
            
            userDefaults.setInteger(idx, forKey: "PlayedEntertainMentYouTubeVideos")
            
            self.switchToSelectedControl(1)
        }
        
        userDefaults.synchronize()
        
        if((self.btnMusic?.selected) != nil)
        {
            
            if(self.currentSelectedMusicRowIndex < self.masterListArray.count)
            {
                self.masterPlayListTableView?.selectRowAtIndexPath(NSIndexPath(forRow: currentSelectedMusicRowIndex, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
        else
        {
            if(self.currentSelectedMusicRowIndex < self.entertainmentArray.count)
            {
                self.masterPlayListTableView?.selectRowAtIndexPath(NSIndexPath(forRow: currentSelectedEntertainRowIndex, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Middle)

            }
        }
    }
    
    
    func resetYouTubePlayList()
    {
        self.loadYouTubeVideoInDetailView()
    }
    func videoCategoryDidSelectedCallbackWithTitle(title:String)
    {
        
        self.isTimeMachineVideoCategorySelected = false
        self.isVideoCategorySelected = true
        self.isEntertainmentSelected = false
        self.currentSelectedMusicRowIndex = 0
        self.currentSelectedEntertainRowIndex = 0
        self.isMusicSegmentSelected = true
        
        
        self.btnMusic?.selected = true
        self.btnEntertainment?.selected = false
        
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setInteger(1, forKey: "PlayedMusicYouTubeVideos")
        userdefaults.synchronize()
        
        self.currentSelection = title
        
    }
    func onlyButtonDidSelectedCallbackWithVivecaSearch(VivecaSearch:Search)
    {
        self.isTimeMachineVideoCategorySelected = false
        self.isVideoCategorySelected = false
        self.isOnlyButtonSelected = true
        self.isEntertainmentSelected = false
        self.isMusicSegmentSelected = true
        
//        let 
    }
    func similarButtonDidSelectedCallbackWithVivecaSearch(VivecaSearch:Search)
    {
        self.isTimeMachineVideoCategorySelected = false
        self.isVideoCategorySelected = false
        self.isOnlyButtonSelected = false
        
    }
    func loadOnGettingPlayList()
    {
        self.resetYouTubePlayList()
        self.masterPlayListTableView?.reloadData()
        
        if((self.btnMusic?.selected) != nil)
        {
            if(self.currentSelectedMusicRowIndex < self.masterListArray.count)
            {
                self.masterPlayListTableView?.selectRowAtIndexPath(NSIndexPath(forRow: self.currentSelectedMusicRowIndex, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
        else
        {
            if(self.currentSelectedMusicRowIndex < self.entertainmentArray.count)
            {
                self.masterPlayListTableView?.selectRowAtIndexPath(NSIndexPath(forRow: self.currentSelectedEntertainRowIndex, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Middle)

            }
        }
    }
    
    let kService_Success = 200
    
    /*===================================================================================================================================================*/
    func GetMusicVideosByYearHandler(musicList:NSDictionary)
    {
        let error:NSDictionary  = musicList["error"] as! NSDictionary
        
        if(error["code"]?.integerValue == kService_Success)
        {
            let dic:NSDictionary = musicList["result"] as! NSDictionary
            let result:NSArray = dic["music"] as! NSArray
            
            self.masterListArray.removeAllObjects()
            
            let array:NSMutableArray = NSMutableArray()
            
            for(var i:Int = 0; i<result.count; i++)
            {
                let dictionary:NSDictionary = result[i] as! NSDictionary
                
                let musicList:MusicList = MusicList()
                musicList.info = dictionary["info"] as? String
                musicList.musicurl = NSURL(string: (dictionary["musicurl"] as? String)!)
                musicList.title = dictionary["title"] as? String
                musicList.year = dictionary["year"] as? String
                musicList.iN = dictionary["In"] as? String
                musicList.infoUrl = NSURL(string: (dictionary["info-url"] as? String)!)
                musicList.position = dictionary["position"] as? NSInteger
                musicList.aux = dictionary["Aux"] as? String
                
                array.addObject(musicList)
            }
            
            self.masterListArray = NSMutableArray(array: array)
            self.masterMusicArray = NSMutableArray(array: array)
            
            if(self.btnMusic?.selected == true){
                self.masterPlayListTableView?.reloadData()
                
                
//                let timeMachine:MusicList = self.masterListArray.objectAtIndex(0) as! MusicList
                
                
                
                if((self.btnMusic?.selected) == true)
                {
                    self.previousSelectedMusicRowIndex = self.currentSelectedMusicRowIndex
                    self.isSelectedFromMusic = true
                    self.currentSelectedMusicRowIndex = 0
                }
                else
                {
                    self.previousSelectedEntertainRowIndex = self.currentSelectedEntertainRowIndex
                    self.isSelectedFromEntertainment = true
                    self.currentSelectedEntertainRowIndex = 0
                }
                
                self.isSelectedFromDidSelect = true
                
                self.masterPlayListTableView?.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
                self.loadYouTubeVideoInDetailView()
                
                self.loadYouTubeVideoInDetailView()

            }
            
        }
    }
    func GetEntertainmentVideosByYearHandler(entertainmentList:NSDictionary)
    {
        self.isTimeMachineVideoCategorySelected = true
        
        
        let error:NSDictionary  = entertainmentList["error"] as! NSDictionary
        
        if(error["code"]?.integerValue == kService_Success)
        {
            let dic:NSDictionary = entertainmentList["result"] as! NSDictionary
            let result:NSArray = dic["entertainment"] as! NSArray
            
            self.masterEntertainmentArray.removeAllObjects()
            
            let array:NSMutableArray = NSMutableArray()
            
            for(var i:Int = 0; i<result.count; i++)
            {
                let dictionary:NSDictionary = result[i] as! NSDictionary
                
                let musicList:VideoList = VideoList()
                musicList.info = dictionary["info"] as? String
                musicList.enturl = NSURL(string: (dictionary["enturl"] as? String)!)
                musicList.title = dictionary["title"] as? String
                musicList.iN = dictionary["In"] as? String
                musicList.infoUrl = NSURL(string: (dictionary["info-url"] as? String)!)
                musicList.position = dictionary["position"] as? NSInteger
                musicList.aux = dictionary["Aux"] as? String
                
                array.addObject(musicList)
            }
            
            self.entertainmentArray = NSMutableArray(array: array)
            self.masterEntertainmentArray = NSMutableArray(array: array)
            
            if(self.btnMusic?.selected == false){
            
                self.masterPlayListTableView?.reloadData()
                
                if((self.btnMusic?.selected) == true)
                {
                    self.previousSelectedMusicRowIndex = self.currentSelectedMusicRowIndex
                    self.isSelectedFromMusic = true
                    self.currentSelectedMusicRowIndex = 0
                }
                else
                {
                    self.previousSelectedEntertainRowIndex = self.currentSelectedEntertainRowIndex
                    self.isSelectedFromEntertainment = true
                    self.currentSelectedEntertainRowIndex = 0
                }
                
                self.isSelectedFromDidSelect = true
                
                self.masterPlayListTableView?.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
                self.loadYouTubeVideoInDetailView()
                
                self.loadYouTubeVideoInDetailView()

            }
        }

        
    }
    func GetYearListHandler(yearList:NSDictionary)
    {
        
    }
    func didDownloadAdvertisementList(advertisementList:NSDictionary)
    {
        
    }
    func diFailwebservice()
    {
        
    }
    
    
    func GetSearchMusicHandler(value:NSMutableArray)
    {
        self.isTimeMachineVideoCategorySelected = true
        
        if(value.isKindOfClass(NSError))
        {
            print("Error")
            return
        }
        
        let result:NSMutableArray = value
        self.masterListArray = result
        
        if(self.masterListArray.count == 0)
        {
            self.masterListArray.removeAllObjects()
        }
        self.masterPlayListTableView?.reloadData()
        
    }
    func GetSearchEntertainmentHandler(value:NSMutableArray)
    {
        self.isTimeMachineVideoCategorySelected = true
        
        if(value.isKindOfClass(NSError))
        {
            print("error")
            return
        }
        
        let result:NSMutableArray = value
        self.entertainmentArray = result
        
        if(self.entertainmentArray.count == 0)
        {
            self.entertainmentArray.removeAllObjects()
        }
        self.masterPlayListTableView?.reloadData()
        
    }
    
    /*===================================================================================================================================================*/
    
    func nextButtonDidTouchedCallback()
    {
        self.masterPlayListTableView?.reloadData()
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if((self.btnMusic?.selected) == true)
        {
            let playedMusicYouTubeVideos:Int = userDefaults.integerForKey("PlayedMusicYouTubeVideos")
            let allowedMusicYouTubeVideos:Int = userDefaults.integerForKey("AllowedMusicYouTubeVideos")
            
            if(playedMusicYouTubeVideos <= allowedMusicYouTubeVideos)
            {
                if(self.currentSelectedMusicRowIndex < (self.masterListArray.count - 1))
                {
                    self.isSelectedFromMusic = true
                    
                    userDefaults.setInteger((playedMusicYouTubeVideos+1), forKey: "PlayedMusicYouTubeVideos")
                    self.currentSelectedMusicRowIndex++
                    
                    self.loadOnGettingPlayList()
                }
            }
            else
            {
                self.isSelectedFromEntertainment = true
                userDefaults.setInteger(1, forKey: "PlayedMusicYouTubeVideos")
                
                self.switchToSelectedControl(1)
                self.loadOnGettingPlayList()
            }
        }
        else
        {
            let playedEntertainMentYouTubeVideos:Int = userDefaults.integerForKey("PlayedEntertainMentYouTubeVideos")
            let allowedEntertainMentYouTubeVideos:Int = userDefaults.integerForKey("AllowedEntertainMentYouTubeVideos")
            
            if(playedEntertainMentYouTubeVideos <= allowedEntertainMentYouTubeVideos)
            {
                
                if(self.currentSelectedEntertainRowIndex < self.entertainmentArray.count-1)
                {
                    self.isSelectedFromEntertainment = true
                    
                    userDefaults.setInteger(playedEntertainMentYouTubeVideos+1, forKey: "PlayedEntertainMentYouTubeVideos")
                    self.currentSelectedEntertainRowIndex++
                    self.loadOnGettingPlayList()
                }
            }
            else
            {
                self.isSelectedFromMusic = true
                
                userDefaults.setInteger(1, forKey: "PlayedEntertainMentYouTubeVideos")
                
                self.switchToSelectedControl(0)
                self.loadOnGettingPlayList()
            }
        }
        
        userDefaults.synchronize()
    }
    func nextButtonAltDidTouchedCallback()
    {
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if((self.btnMusic?.selected) == true)
        {
            let playedMusicYouTubeVideos:Int = userDefaults.integerForKey("PlayedMusicYouTubeVideos")
            let allowedMusicYouTubeVideos:Int = userDefaults.integerForKey("AllowedMusicYouTubeVideos")
            
            if(playedMusicYouTubeVideos <= allowedMusicYouTubeVideos)
            {
                if(self.currentSelectedMusicRowIndex < self.masterListArray.count - 1)
                {
//                    self.load
                    
                    self.loadYouTubeVideoInDetailView(true, currentMusicRowIndexAlt: currentSelectedMusicRowIndex+1, currentEntertainRowIndexAlt: currentSelectedEntertainRowIndex)
                }
            }
            else
            {
                self.loadYouTubeVideoInDetailView(false, currentMusicRowIndexAlt: currentSelectedMusicRowIndex, currentEntertainRowIndexAlt: currentSelectedEntertainRowIndex+1)

            }
        }
        else
        {
            let playedMusicYouTubeVideos:Int = userDefaults.integerForKey("PlayedEntertainMentYouTubeVideos")
            let allowedMusicYouTubeVideos:Int = userDefaults.integerForKey("AllowedEntertainMentYouTubeVideos")

            
            if(playedMusicYouTubeVideos <= allowedMusicYouTubeVideos)
            {
                if(self.currentSelectedMusicRowIndex < self.masterListArray.count - 1)
                {
                    //                    self.load
                    self.loadYouTubeVideoInDetailView(false, currentMusicRowIndexAlt: currentSelectedMusicRowIndex, currentEntertainRowIndexAlt: currentSelectedEntertainRowIndex + 1)

                }
            }
            else
            {
                self.loadYouTubeVideoInDetailView(true, currentMusicRowIndexAlt: currentSelectedMusicRowIndex+1, currentEntertainRowIndexAlt: currentSelectedEntertainRowIndex)

            }
        }
    }
    
    
    func GetMusicVideosByYearForChangingTypeHandler(value:NSMutableArray)
    {
        if(value.isKindOfClass(NSError))
        {
            return
        }
        
        let result:NSMutableArray = value
        self.masterListArray = result
        
        if(self.currentSelectedEntertainRowIndex < self.masterListArray.count - 1)
        {
            self.currentSelectedEntertainRowIndex++
            self.loadOnGettingPlayList()
        }
        else
        {
            self.currentSelectedMusicRowIndex++
            
            self.btnMusic?.selected = true
            self.btnEntertainment?.selected = false
            self.isMusicSegmentSelected = true
        }
    }
    func GetEntertainmentVideosByYearForChangingTypeHandler(value:NSMutableArray)
    {
        if(value.isKindOfClass(NSError))
        {
            return
        }
        
        let result:NSMutableArray = value
        self.masterListArray = result
        
        if(self.currentSelectedMusicRowIndex < self.masterListArray.count - 1)
        {
            self.currentSelectedMusicRowIndex++
            self.loadOnGettingPlayList()
        }
        else
        {
            self.currentSelectedEntertainRowIndex++
            
            self.btnMusic?.selected = true
            self.btnEntertainment?.selected = false
            self.isMusicSegmentSelected = false
        }
    }
    //pragma mark -
    //pragma mark - Detail ViewController Delegate
    //pragma mark -
    func timeMachineDidSelectedCallbackWithTitle1(title:String)
    {
        self.currentSelection = title
        
        let webmanager:WebserviceManager = WebserviceManager()
        webmanager.delegate = self
        
        webmanager.getMusicList(title)
        webmanager.getEntertainmentList(title)
        
        self.isTimeMachineVideoCategorySelected = true
        self.isEntertainmentSelected  = false
        self.currentSelectedMusicRowIndex = 0
        self.currentSelectedEntertainRowIndex = 0
        self.isMusicSegmentSelected =  true
        
        let userdefaults = NSUserDefaults.standardUserDefaults()
        userdefaults.setInteger(1, forKey: "PlayedMusicYouTubeVideos")
        userdefaults.synchronize()
    }
    func searchTextRemovedCallback(strText:String)
    {
        let lowerString = strText.lowercaseString
        self.masterListArray.removeAllObjects()
        
        
        for(var i:Int = 0; i<self.masterMusicArray.count; i++)
        {
            let music:MusicList = self.masterMusicArray.objectAtIndex(i) as! MusicList
            
            if(strText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0)
            {
                self.masterListArray.addObject(music)
                continue
            }
            
            let strArray:NSArray = (music.title?.componentsSeparatedByString(" #"))!
            let subStr:NSString = strArray.objectAtIndex(0).lowercaseString
            let range:NSRange = subStr.rangeOfString(lowerString)
            
            if(range.location != NSNotFound)
            {
                self.masterListArray.addObject(music)
                
            }
        }
        
        self.entertainmentArray.removeAllObjects()

        for(var i:Int = 0; i<self.masterEntertainmentArray.count; i++)
        {
            let music:VideoList = self.masterEntertainmentArray.objectAtIndex(i) as! VideoList
            
            if(strText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0)
            {
                self.entertainmentArray.addObject(music)
                continue
            }
            
            let strArray:NSArray = (music.title?.componentsSeparatedByString(" #"))!
            let subStr:NSString = strArray.objectAtIndex(0).lowercaseString
            let range:NSRange = subStr.rangeOfString(lowerString)
            
            if(range.location != NSNotFound)
            {
                self.entertainmentArray.addObject(music)
                
            }
        }
        
        self.masterPlayListTableView?.reloadData()
    }
    
    
    /**********************************/
    
    
    func configureInterfaceOrientation(toInterfaceOrientation:UIInterfaceOrientation)
    {
        
    }
//    override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool {
//        
//        return true
//    }
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        self.configureInterfaceOrientation(toInterfaceOrientation)
        
//        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
    }
    func switchToSelectedControl(selectedIndex:Int)
    {
        if(selectedIndex == 1)
        {
            self.isMusicSegmentSelected = false
            self.btnEntertainment?.selected = true
            self.btnMusic?.selected = false
        }
        else
        {
            self.isMusicSegmentSelected = true
            self.btnMusic?.selected = true
            self.btnEntertainment?.selected = false
        }
        
        self.masterPlayListTableView?.reloadData()

    }
    
    // Button actions
    func musicEntertainSelectionDidChanged(btn:UIButton)
    {
        let selectedBtn:UIButton = btn
        selectedBtn.selected = true
        
        if(selectedBtn.tag == 0)
        {
            self.isMusicSegmentSelected = true
            self.btnEntertainment?.selected = false
        }
        else
        {
            self.isMusicSegmentSelected = false
            self.btnMusic?.selected = false
        }
        
        self.masterPlayListTableView?.reloadData()
    }
    
    override func awakeFromNib() {
        
        self.preferredContentSize = CGSizeMake(320, 800)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.previousSelectedMusicRowIndex = 0
        self.previousSelectedEntertainRowIndex = 0
        
        
        let masterBackgroundView:UIView = UIView(frame: CGRectMake(5, 51, 314, 717))
        masterBackgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "list-bg")!)
//        self.view.addSubview(masterBackgroundView)
        self.view.backgroundColor = UIColor.clearColor()
        
        let vcs:NSArray = (self.splitViewController?.viewControllers)!;
        self.detailViewController = vcs.lastObject?.topViewController as? DetailViewController
        self.detailViewController?.masterDelegate = self
        
        self.addMasterListTableOnVew()
        
        self.btnMusic = UIButton(frame: CGRectMake(0, 0, 160, 64))
        self.btnMusic?.tag = 0
        self.btnMusic?.setImage(UIImage(named: "button-music.png"), forState: UIControlState.Normal)
        self.btnMusic?.setImage(UIImage(named: "button-music-active.png"), forState: UIControlState.Selected)
        self.btnMusic?.setImage(UIImage(named: "button-music-press.png"), forState: UIControlState.Highlighted)
        self.btnMusic?.addTarget(self, action: Selector("musicEntertainSelectionDidChanged:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnEntertainment = UIButton(frame: CGRectMake(160, 0, 160, 64))
        self.btnEntertainment?.setImage(UIImage(named: "button-entertainment.png"), forState: UIControlState.Normal)
        self.btnEntertainment?.setImage(UIImage(named: "button-entertainment-active.png"), forState: UIControlState.Selected)
        self.btnEntertainment?.setImage(UIImage(named: "button-entertainment-press.png"), forState: UIControlState.Highlighted)
        self.btnEntertainment?.addTarget(self, action: Selector("musicEntertainSelectionDidChanged:"), forControlEvents: UIControlEvents.TouchUpInside)

        
        self.btnEntertainment?.tag = 1
        self.btnMusic?.selected = true
        self.view.addSubview(self.btnMusic!)
        self.view.addSubview(self.btnEntertainment!);
        
        self.isMusicSegmentSelected = true
        
        self.currentSelection = "1980";
//        self.detailViewController?.masterDelegate?.timeMachineDidSelectedCallbackWithTitle1(self.currentSelection!)
//        [self.detailViewController.masterDelegate timeMachineDidSelectedCallbackWithTitle:self.currentSelection];
        
        
        // register xib
        //MasterListCell
        //CellIdentifier
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let orientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        self.configureInterfaceOrientation(orientation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // UITableView datasource & delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if((self.btnMusic?.selected) == true)
        {
            return self.masterListArray.count
        }
        else
        {
            return self.entertainmentArray.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier = "CellIdentifier"
        let cell:MasterListCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! MasterListCell
        
//        if(tableView.dequeueReusableCellWithIdentifier(CellIdentifier)?.isKindOfClass(MasterListCell) == nil)
//        {
//            cell = MasterListCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
            cell.initWithCell(Int(indexPath.row))
        
        
        self.masterCell = cell
        
        cell.cellTextLabel?.frame = CGRectMake(15, 6, 270, 34)
        cell.cellTextLabel?.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        if(self.masterListArray.count != 0 && self.entertainmentArray.count != 0)
        {
            if((self.btnMusic?.selected) == true)
            {
                if(self.isSelectedFromMusic == true)
                {
                    if(self.currentSelectedMusicRowIndex == indexPath.row)
                    {
                        cell.cellTextLabel?.frame = CGRectMake(35, 6, 260, 34)
                        self.isSelectedFromMusic = false
                    }
                    else
                    {
                        cell.cellTextLabel?.frame = CGRectMake(15, 6, 270, 34)
                    }
                }
            }
            else
            {
                if(self.isSelectedFromEntertainment == true)
                {
                    if(self.currentSelectedEntertainRowIndex == indexPath.row)
                    {
                        cell.cellTextLabel?.frame = CGRectMake(35, 6, 260, 34)
                        self.isSelectedFromEntertainment = false
                    }
                    else
                    {
                        cell.cellTextLabel?.frame = CGRectMake(15, 6, 270, 34)
                    }
                }
            }
        }
        
        if((self.btnMusic?.selected)  == true)
        {
            if(self.masterListArray.count != 0)
            {
                let musicList:MusicList = self.masterListArray.objectAtIndex(indexPath.row) as! MusicList
                cell.setMenuItem(musicList.title!)
                cell.detailTextLabel?.text = ""
            }
        }
        else
        {
            if(self.entertainmentArray.count != 0)
            {
                let musicList:VideoList = self.entertainmentArray.objectAtIndex(indexPath.row) as! VideoList
                cell.setMenuItem(musicList.title!)
                cell.detailTextLabel?.text = ""
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerview = UIView()
        footerview.backgroundColor = UIColor.clearColor()
        
        
        return footerview
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if((self.btnMusic?.selected) == true)
        {
            self.previousSelectedMusicRowIndex = self.currentSelectedMusicRowIndex
            self.isSelectedFromMusic = true
            self.currentSelectedMusicRowIndex = indexPath.row as Int
        }
        else
        {
            self.previousSelectedEntertainRowIndex = self.currentSelectedEntertainRowIndex
            self.isSelectedFromEntertainment = true
            self.currentSelectedEntertainRowIndex = indexPath.row as Int
        }
        
        self.isSelectedFromDidSelect = true
        tableView.reloadData()
        tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        
        self.loadYouTubeVideoInDetailView()
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


