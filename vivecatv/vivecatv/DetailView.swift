//
//  DetailView.swift
//  vivecatv
//
//  Created by Solar Jang on 9/21/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailView: UIView, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UISearchBarDelegate, UITextViewDelegate, UIScrollViewDelegate, WebserviceManagerDelegate, AKPickerViewDataSource, AKPickerViewDelegate {
    
    var delegate:DetailViewDelegate?
    var timeMachineArray:NSArray = NSArray()
    var tweeterArray:NSArray = NSArray()
    var shareButton:UIButton?
    var firstDetialView:UIView?
    var secondDetailView:UIView?
    var thirdDetailView:UIView?
    
    var vivecaSearch:Search?
    var isOnlyCliked:Bool?
    var selectYearInteger:Int?
    var indexForYear:Int?
    
    var accountNameLabel:String?
    var tweetTest:String?
    var timeLabel:String?
    var searchText:String?
    var timeMachineYear:String?
    var profileImageData:NSData?
    
    
    var lblInfo:UILabel?
    var txtViewLyrics:UITextView?
    var imgViewInfo:UIImageView?
    
    var noOfFearturedButtons:Int?
    
    var maxMusicT:Int = 0
    var maxEntertainmentT:Int = 0

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func addHeaderViewOnDetailView()
    {
        let localView:UIView = UIView(frame: CGRectMake(5, 49, 693, 40))
        localView.backgroundColor = UIColor.clearColor()
        localView.userInteractionEnabled = true
        self.firstDetialView = localView
        self.addSubview(self.firstDetialView!)
        
        self.addSearchBarOnDetailFirstView(1102)
        self.addYearScrollViewOnFirstView(1111)
        self.addSelectYearLabel(1112)
        
    }
    func addPlayerViewOnDetailView()
    {
        let localView:UIView = UIView(frame: CGRectMake(0, 94, 680, 460))
        localView.backgroundColor = UIColor.clearColor()
        localView.userInteractionEnabled = true
        
        self.secondDetailView = localView
        self.addSubview(self.secondDetailView!)
        
        let playerBackgroundView:UIImageView = UIImageView(image: UIImage(named: "videofarame.png"))
        playerBackgroundView.frame = CGRectMake(5, 6, 692, 338)
        self.secondDetailView?.addSubview(playerBackgroundView)
        
        self.addNextPlayButtonOnSecondView("NextPlayButton.png", tag: 2002)
        
        self.addLabelOnSecondView("music.png", tag: 2004)
        self.addLabelOnSecondView("entertainment.png", tag: 2005)
        self.addSliderOnSecondView(2008)
        self.addInfoOnSecondView(2012)
        self.addMusicLabelToSetValue(2014)
        self.addMusicLabelToSetValue(2015)
        self.addShareButton(2016)
        
    }
    func addTweeterViewOnDetailView()
    {
        let localView:UIView = UIView(frame: CGRectMake(5, 544, 693, 185))
        localView.backgroundColor = UIColor.clearColor()
        localView.userInteractionEnabled = true
        self.thirdDetailView = localView
        
        self.addSubview(self.thirdDetailView!)
        
        self.addInfoSection()
    }
    func addInfoSection()
    {
        let frame:CGRect = CGRectMake(13, 24, 670, 150)
        let imgView:UIImageView = UIImageView(frame: frame)
        imgView.image = UIImage(named: "tweets-bg.png")
        
        self.thirdDetailView?.addSubview(imgView)
        
        let infoLabel:UILabel = UILabel(frame: CGRectMake(150, 30, 250, 21))
        infoLabel.backgroundColor = UIColor.clearColor()
        infoLabel.textColor = UIColor.redColor()
        infoLabel.font = UIFont(name: "Helvetica", size: 13)
        self.lblInfo = infoLabel
        
        
        let info:UIImageView = UIImageView(frame: CGRectMake(30, 30, 64, 64))
        info.backgroundColor = UIColor.clearColor()
        info.layer.borderColor = UIColor.whiteColor().CGColor
        info.layer.borderWidth = 1
        self.imgViewInfo = info
        
        let txtView:UITextView = UITextView(frame: CGRectMake(112, 60, 550, 110))
        txtView.backgroundColor = UIColor.clearColor()
        txtView.text = ""
        txtView.font = UIFont(name: "Helvetica", size: 13)
        txtView.textColor = UIColor.whiteColor()
        txtView.editable = false
        self.txtViewLyrics = txtView
        
        
        self.thirdDetailView?.addSubview(self.txtViewLyrics!)
        self.thirdDetailView?.addSubview(self.imgViewInfo!)
        self.thirdDetailView?.addSubview(self.lblInfo!)
        
    }
    func addShareButton(tag:Int)
    {
        
    }
    func addViewOnDetailView(tag:Int)
    {
        
        let localView:UIView = UIView(frame: CGRectZero)
        localView.userInteractionEnabled = true
        localView.tag = tag
        self.addSubview(localView)
        
    }
    func addSearchBarOnDetailFirstView(tag:Int)
    {
        let frame:CGRect = CGRectMake(15, 1, 263, 60)
        
        let imgView:UIImageView = UIImageView(frame: frame)
        imgView.image = UIImage(named: "field.png")
        self.firstDetialView?.addSubview(imgView)
        
        
        let detailSearchBar:UISearchBar = UISearchBar()
        detailSearchBar.tag = tag
        detailSearchBar.barTintColor = UIColor.clearColor()
        detailSearchBar.backgroundColor = UIColor.clearColor()
        detailSearchBar.frame = CGRectMake(15, 7, 265, 40)
        detailSearchBar.autocapitalizationType = UITextAutocapitalizationType.None
        detailSearchBar.placeholder = "Type here..."
        detailSearchBar.barStyle = UIBarStyle.Default
        detailSearchBar.delegate = self
        detailSearchBar.searchTextPositionAdjustment = UIOffsetMake(30, 0)
        
        for(var i:Int=0; i < detailSearchBar.subviews.count; i++)
        {
            let subView:UIView = detailSearchBar.subviews[i] 
            
            if(subView.isKindOfClass(NSClassFromString("UISearchBarBackground")!))
            {
                subView.removeFromSuperview()
                break;
            }
        }
        
        self.firstDetialView?.addSubview(detailSearchBar)
        self.firstDetialView?.bringSubviewToFront(detailSearchBar)
        
    }
    func addNextPlayButtonOnSecondView(imageName:String, tag:Int)
    {
        let favoriteButton:UIButton = UIButton(type: UIButtonType.Custom)
        favoriteButton.tag = tag
        favoriteButton.frame = CGRectMake(609, 365, 80, 80)
        favoriteButton.setImage(UIImage(named: "button-skip.png"), forState: UIControlState.Normal)
        favoriteButton.setImage(UIImage(named: "button-skip-active.png"), forState: UIControlState.Highlighted)
        favoriteButton.addTarget(self, action: Selector("nextButtonTouched:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.secondDetailView?.addSubview(favoriteButton)
        
    }
    func nextButtonTouched(btn:UIButton)
    {
        self.delegate?.nextButtonDidSelected()
    }
    func addLabelOnSecondView(labelString:String, tag:Int)
    {
        let imageView:UIImageView = UIImageView()
        imageView.tag = tag
        if(imageView.tag == 2004)
        {
            imageView.frame = CGRectMake(20, 354, 60, 34)
        }
        else
        {
            imageView.frame = CGRectMake(420, 354, 140, 35)
        }
        
        imageView.image = UIImage(named: labelString)
        self.secondDetailView?.addSubview(imageView)
        
    }
    func addSliderOnSecondView(tag:Int)
    {
        let detailSlider:UISlider = UISlider(frame: CGRectZero)
        detailSlider.tag = tag
        detailSlider.maximumValue = 5
        detailSlider.minimumValue = 0
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        detailSlider.value = userDefaults.floatForKey("Music_Entertaiment_SLider_value")
        userDefaults.synchronize()
        
        detailSlider.frame = CGRectMake(15, 387, 562, 34)
        detailSlider.userInteractionEnabled = true
        detailSlider.backgroundColor = UIColor(patternImage: UIImage(named: "slider-bg.png")!)
        detailSlider.addTarget(self, action: Selector("sliderDidTOuched:"), forControlEvents: UIControlEvents.TouchUpInside)
        detailSlider.setThumbImage(UIImage(named: "hold.png"), forState: UIControlState.Normal)
        detailSlider.setThumbImage(UIImage(named: "hold-active.png"), forState: UIControlState.Highlighted)
        detailSlider.setMinimumTrackImage(UIImage(named: "slider-bar-active.png"), forState: UIControlState.Normal)
        detailSlider.setMaximumTrackImage(UIImage(named: "slider-bar.png"), forState: UIControlState.Normal)
        
        self.secondDetailView?.addSubview(detailSlider)
        
    }
    func sliderDidTOuched(sender:UISlider)
    {
        let maxMusic:Int = 0
        let maxEntertainment:Int = 0
        
        let slider:UISlider = sender 
        let value:Float = slider.value
        
        self.getMusicEntertainmentLimits(maxEntertainment, maxMusic_p: maxMusic, value: value)
        
        let lbl1:UILabel = self.viewWithTag(2014) as! UILabel
        let lbl2:UILabel = self.viewWithTag(2015) as! UILabel
        
        lbl1.text = "\(self.maxMusicT)"
        lbl2.text = "\(self.maxEntertainmentT)"
        
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setFloat(value, forKey: "Music_Entertaiment_SLider_value")
        userDefaults.setInteger(self.maxMusicT, forKey: "AllowedMusicYouTubeVideos")
        userDefaults.setInteger(self.maxEntertainmentT, forKey: "AllowedEntertainMentYouTubeVideos")
        userDefaults.synchronize()
        
    }
    func addInfoOnSecondView(tag:Int)
    {
        let frame:CGRect = CGRectMake(20, 436, 140, 34)
        let label:UILabel = UILabel(frame: frame)
        label.text = "Info"
        label.font = UIFont(name: "Helvetica", size: 17)
        label.textColor = UIColor.whiteColor()
        self.secondDetailView?.addSubview(label)
        
    }
    func addTweeterLabelName(tag:Int)
    {
        
    }
    func addMusicLabelToSetValue(tag:Int)
    {
        let musicLabel:UILabel = UILabel()
        musicLabel.tag = tag
        musicLabel.backgroundColor = UIColor.clearColor()
        musicLabel.textColor = UIColor.whiteColor()
        
        let maxEntertainment:Int = 0
        let maxMusic:Int  = 0
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let value = userDefaults.floatForKey("Music_Entertaiment_SLider_value")
//        let value1 = userDefaults.floatForKey("Music_Entertaiment_SLider_value")
        
        self.getMusicEntertainmentLimits(maxEntertainment, maxMusic_p: maxMusic, value: value)
        
        userDefaults.synchronize()
        
        if(musicLabel.tag == 2014)
        {
            
            musicLabel.text = "\(self.maxMusicT)"
            musicLabel.frame = CGRectMake(80, 361, 20, 21)
        }
        else
        {
            musicLabel.text = "\(self.maxEntertainmentT)"
            musicLabel.frame = CGRectMake(560, 361, 20, 21)
        }
        
        self.secondDetailView?.addSubview(musicLabel)
        
        
    }
    func addYearScrollViewOnFirstView(tag:Int)
    {
        
        
        let imageView:UIImageView = UIImageView(frame: CGRectMake(426, 1, 253, 60))
        imageView.image = UIImage(named: "select.png")
        imageView.backgroundColor = UIColor.clearColor()
        self.firstDetialView?.addSubview(imageView)
        
        let pickerView:AKPickerView = AKPickerView(frame: CGRectMake(426, 1, 253, 60))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.clearColor()
        pickerView.textColor = UIColor.lightGrayColor()
        
        self.firstDetialView?.addSubview(pickerView)
        
        
        if(self.timeMachineArray.count > 0)
        {
            pickerView.reloadData()
            
            let year:NSNumber = self.timeMachineArray[0] as! NSNumber
            self.delegate?.timeMachineDidSelectedWithTitle("\(year)")
            self.indexForYear = Int(year)

        }
    }
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.timeMachineArray.count
    }
    
    /*
    
    Image Support
    -------------
    Please comment '-pickerView:titleForItem:' entirely and
    uncomment '-pickerView:imageForItem:' to see how it works.
    
    */
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        
        let year:NSNumber = self.timeMachineArray[item] as! NSNumber
        
        return "\(year)"
    }
    func pickerView(pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSizeMake(10, 30)
    }
    
//    func pickerView(pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
//        return UIImage(named: self.titles[item])!
//    }
    
    // MARK: - AKPickerViewDelegate
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
//        print("Your favorite city is \(self.titles[item])")
        
        let year:NSNumber = self.timeMachineArray[item] as! NSNumber

        if(self.timeMachineYear != nil){
            
            if(self.timeMachineYear! != "\(year)")
            {
                self.delegate?.timeMachineDidSelectedWithTitle("\(year)")
                
                self.indexForYear = Int(year)
            }
        
        }
        
        self.timeMachineYear = "\(year)"

        
    }

    
    
    func addTableForTweeter(tag:Int)
    {
        
    }
    func addSelectYearLabel(tag:Int)
    {
        
        let selectYearImageView:UIImageView = UIImageView()
        selectYearImageView.tag = tag
        selectYearImageView.frame = CGRectMake(300, 12, 100,30)
        selectYearImageView.image = UIImage(named:"select-year_Image.png")
        self.firstDetialView?.addSubview(selectYearImageView)
    }
    func addShareView(tag:Int)
    {
        
        if(self.viewWithTag(2017) == nil)
        {
            let tweetView:UIView = UIView(frame: CGRectMake(20, 88, 660, 259))
            tweetView.tag = tag
            tweetView.backgroundColor = UIColor(patternImage: UIImage(named: "ShareBackgroundImage.png")!)
            self.secondDetailView?.addSubview(tweetView)
            
            let tweeterActiveView:UIView = UIView(frame: CGRectMake(15, 15, 635, 162))
            tweeterActiveView.backgroundColor = UIColor(patternImage: UIImage(named: "ShareActiveField.png")!)
            tweetView.addSubview(tweeterActiveView)
            
            self.shareButtonsOnShareView(2018, frame: CGRectMake(15, 190, 100, 40), imageName: "SayButton.png", selectedImage: "SelectedSayButton.png")
            self.shareButtonsOnShareView(2019, frame: CGRectMake(548, 190, 100, 40), imageName: "ClearButton.png", selectedImage: "SelectedClearButton.png")
            
            self.shareButton?.setBackgroundImage(UIImage(named: "button-share.png"), forState: UIControlState.Normal)
        }
        
    }
    func getMusicEntertainmentLimits(maxEntertainment_p:Int, maxMusic_p:Int, value:Float)
    {
        if(value >= 0.5 && value < 1.5)
        {
            self.maxMusicT = 4
            self.maxEntertainmentT = 1
        }
        else if(value >= 1.5 && value < 2.5)
        {
            self.maxMusicT = 3
            self.maxEntertainmentT = 2
        }
        else if(value >= 2.4 && value < 2.6)
        {
            self.maxMusicT = 1
            self.maxEntertainmentT = 1
        }
        else if(value >= 2.6 && value < 3.5)
        {
            self.maxMusicT = 2
            self.maxEntertainmentT = 3
        }
        else if(value >= 3.5 && value < 4.5)
        {
            self.maxMusicT = 1
            self.maxEntertainmentT = 4
            
        }
        else if(value >= 4.5)
        {
            self.maxMusicT = 0
            self.maxEntertainmentT = 5
        }
        else if(value < 0.5)
        {
            self.maxMusicT = 5
            self.maxEntertainmentT = 0
        }
    }
    func shareButtonsOnShareView(tag:Int, frame:CGRect, imageName:String, selectedImage:String)
    {
        let button:UIButton = UIButton(type: UIButtonType.Custom)
        button.tag = tag
        button.frame = frame
        button.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named:selectedImage), forState: UIControlState.Highlighted)
        
        button.addTarget(self, action: Selector("syaOrClearButtonIsClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.viewWithTag(2017)?.addSubview(button)
    }
    func syaOrClearButtonIsClicked(sender:UIButton)
    {
        self.viewWithTag(2017)?.removeFromSuperview()
    }
    
    /*===================================================================================================================================================*/
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
//        scrollView.reloadInputViews()
//        
//        let pageWidth:Float = 56
//        let page:Int = floor((Float(scrollView.contentOffset.x) + 90 - pageWidth/2)/pageWidth) /  2
    }
    
    //////
    
    func getFeaturedVideoList()
    {
        let webService:WebserviceManager = WebserviceManager()
        webService.delegate = self
        webService.getYearsList()
        
    }
    
    // rest webservice delegate
    func GetMusicVideosByYearHandler(musicList:NSDictionary)
    {
    }
    func GetEntertainmentVideosByYearHandler(entertainmentList:NSDictionary)
    {
    }
    func didDownloadAdvertisementList(advertisementList:NSDictionary)
    {
    }
    func diFailwebservice()
    {
    }
    func GetYearListHandler(yearList: NSDictionary) {
        
        let error:NSDictionary = yearList["error"] as! NSDictionary
        
        if(error["code"]?.integerValue == 200)
        {
            let res:NSDictionary = yearList["result"] as! NSDictionary
            let arr:NSArray = res["Years"] as! NSArray
            
            self.timeMachineArray = arr.sortedArrayUsingSelector("compare:")
            
            self.addYearScrollViewOnFirstView(1111)
            
            if(self.timeMachineArray.count > 0)
            {
                indexForYear = self.timeMachineArray[0].integerValue
                
                
            }
            
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.getFeaturedVideoList()
        self.addHeaderViewOnDetailView()
        self.addPlayerViewOnDetailView()
        self.addTweeterViewOnDetailView()
        
        let topBarImageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 704, 64))
        topBarImageView.image = UIImage(named: "top-pannel.png")
        self.addSubview(topBarImageView)
        
        let localarray:NSArray = NSArray(objects: "", "")
        self.tweeterArray = localarray
        
        self.profileImageData = NSData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // textView & searchbar delegate
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        return false
        
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        let result:String = (searchBar.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!
        if(result.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0)
        {
            self.searchText = searchBar.text
        }
        else
        {
            self.searchText = ""
            self.delegate?.videoCategoryDidSelectedWithTitle("Disco")
        }
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
//        let result:String = (searchBar.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!
        searchBar.showsCancelButton = false
        
        self.delegate?.searchTextRemovedCallback(searchText)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    
    
    /// tableview delegate & datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tweeterArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cellindentifier:String = "Cell"
        
        var tweeterCell:TweeterTableViewCell?
        tweeterCell = tableView.dequeueReusableCellWithIdentifier(cellindentifier) as? TweeterTableViewCell
        if tweeterCell == nil
        {
            tweeterCell = TweeterTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellindentifier)
            tweeterCell?.textLabel?.textColor = UIColor.whiteColor()
        }
        
        if(tweeterCell?.tag == 3017)
        {
            tweeterCell?.initWithTweeterAcountName(accountNameLabel!, tweetTest: tweetTest!, timeLabel: timeLabel!, image: profileImageData!)
            tweeterCell?.textLabel?.text = self.tweeterArray.objectAtIndex(indexPath.row) as? String
            tweeterCell?.selectionStyle = UITableViewCellSelectionStyle.None
            tweeterCell?.backgroundView = UIImageView(image: UIImage(named: "TweeterSectionBackgroundImage.png"))
        }
        
        return tweeterCell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

}




protocol DetailViewDelegate
{
    func nextButtonDidSelected()
    func onlyButtonDidSelectedWithVivecaSearch(vivecaSearch:Search)
    func similarButtonDidSelectedWithVivecaSearch(vivecaSearch:Search)
    func timeMachineDidSelectedWithTitle(title:String)
    func videoCategoryDidSelectedWithTitle(title:String)
    func twitterShareButtonClicked()
    func searchTextRemovedCallback(query:String)
}

//extension DetailViewDelegate
//{
//    func nextButtonDidSelected()
//    {
////        let musicPlayer:MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer()
////        NSUserDefaults.standardUserDefaults().setFloat(musicPlayer.volume, forKey: "MusicVolumn")
//    }
//    func onlyButtonDidSelectedWithVivecaSearch(vivecaSearch:Search)
//    {
//        
//    }
//    func similarButtonDidSelectedWithVivecaSearch(vivecaSearch:Search)
//    {
//        
//    }
//    func timeMachineDidSelectedWithTitle(title:String)
//    {
//        
//    }
//    func videoCategoryDidSelectedWithTitle(title:String)
//    {
//        
//    }
//    func twitterShareButtonClicked()
//    {
//        
//    }
//    func searchTextRemovedCallback(query:String)
//    {
//        
//    }
//}
