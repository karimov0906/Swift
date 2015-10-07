//
//  MainViewController.swift
//  TrendingContent
//
//  Created by Ashish Gupta on 17/08/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

enum Direction {
    case Left, Right
}

class MainViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionViewBusiness: UICollectionView!
    @IBOutlet weak var collectionViewEntertainment: UICollectionView!
    @IBOutlet weak var collectionViewLifestyle: UICollectionView!
    @IBOutlet weak var collectionViewNews: UICollectionView!
    @IBOutlet weak var collectionViewSports: UICollectionView!
    
    @IBOutlet weak var tableVIew: UITableView!
    
    @IBOutlet var top3Buttons: [UIButton]!
    @IBOutlet var top3Image: [UIImageView]!
    @IBOutlet var titleLabel: [UILabel]!
    @IBOutlet var artistLabel: [UILabel]!
    
    @IBOutlet weak var socialView: UIView!
    @IBOutlet weak var socialWebView: UIWebView!
    
    @IBOutlet weak var youtubeView: UIView!
    @IBOutlet var webViews: [UIWebView]!
    
    @IBOutlet weak var scrollVIew: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!

    @IBOutlet weak var searchTextField: UITextField!

    
    // MARK: Priavte variables
    private var isLoading: Bool = false
    
    private var feedsBusiness: [Feed] = []
    private var feedEntertainment: [Feed] = []
    private var feedLifeStyle: [Feed] = []
    private var feedNews: [Feed] = []
    private var feedSports: [Feed] = []
    
    private var feedsBusinessAll: [Feed] = []
    private var feedEntertainmentAll: [Feed] = []
    private var feedLifeStyleAll: [Feed] = []
    private var feedNewsAll: [Feed] = []
    private var feedSportsAll: [Feed] = []
    
    private var feedSocial: [Feed] = []
    private var twitterArray: [Feed] = []
    private var feedsYoutube: [Feed] = []
    private var feedsTop3: [Feed] = []

    private var timer = NSTimer()
    
    private var _searchText: String?
    private var searchBtnClicked = false
    
    private var selectedIndex: Int = 0 {
        didSet {
            for button in top3Buttons {
                button.selected = false
            }
            let button = top3Buttons[selectedIndex]
            button.selected = true
            
            self.top3Trends()
        }
    }
    private var top3Types :[String] = ["songs","movies","episodes","apps","books"]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Search Bar style
        searchTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        searchTextField.textColor = UIColor.whiteColor()
        let color:UIColor = UIColor.lightGrayColor()
        searchTextField.attributedPlaceholder = NSAttributedString(string:"Enter Search....",
            attributes:[NSForegroundColorAttributeName: color])
        self.view.addSubview(searchTextField)
        
         timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        tableVIew.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get data from cache
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.Business.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feedsBusinessAll = cachedFeeds
                self.collectionViewBusiness.reloadData()
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.Entertainment.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feedEntertainmentAll = cachedFeeds
                self.collectionViewEntertainment.reloadData()
            }
        }
        
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.LifeStyle.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feedLifeStyleAll = cachedFeeds
                self.collectionViewLifestyle.reloadData()
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.News.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feedNewsAll = cachedFeeds
                self.collectionViewNews.reloadData()
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.Sports.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feedSportsAll = cachedFeeds
                self.collectionViewSports.reloadData()
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData("TwitterFeeds") as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.twitterArray = cachedFeeds
                self.tableVIew.reloadData()
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData("SocialFeeds") as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feedSocial = cachedFeeds
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData("YoutubeFeeds") as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feedsYoutube = cachedFeeds
                self.loadYoutubeTrends()
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData("Top3Feeds") as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feedsTop3 = cachedFeeds
                self.selectedIndex = 0
            }
        }

        
        // Make Request to get updated feeds
        makeRequest()
    }
    
    //MARK: Support Landcape
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionViewBusiness.collectionViewLayout.invalidateLayout()
        collectionViewEntertainment.collectionViewLayout.invalidateLayout()
        collectionViewLifestyle.collectionViewLayout.invalidateLayout()
        collectionViewNews.collectionViewLayout.invalidateLayout()
        collectionViewSports.collectionViewLayout.invalidateLayout()
        
        scrollVIew.contentSize.height = CGRectGetMaxY(footerView.frame)
        self.rotateAllStories()
    }
    
    //MARK: Web Request for updated data
    private func makeRequest() {
        NetworkManager.sharedInstance.getBusinessStories({ (feed: BusinessFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feedsBusinessAll = feedArray.feeds
                
                // Update Cache
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feedsBusiness)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: FeedType.Business.description)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionViewBusiness.reloadData()
                })
            }
            else
            {
                //Show Error
            }
        })
        
        NetworkManager.sharedInstance.getEntertainmentStories({ (feed: EntertainmentFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feedEntertainmentAll = feedArray.feeds
                
                // Update Cache
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feedEntertainment)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: FeedType.Entertainment.description)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionViewEntertainment.reloadData()
                })
            }
            else
            {
                //Show Error
            }
        })
        
        
        NetworkManager.sharedInstance.getLifestyleStories({ (feed: LifestyleFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feedLifeStyleAll = feedArray.feeds
                
                // Update Cache
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feedLifeStyle)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: FeedType.LifeStyle.description)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionViewLifestyle.reloadData()
                })
            }
            else
            {
                //Show Error
            }
        })
        
        
        NetworkManager.sharedInstance.getNewsStories({ (feed: NewsFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feedNewsAll = feedArray.feeds
                
                // Update Cache
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feedNews)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: FeedType.News.description)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionViewNews.reloadData()
                })
            }
            else
            {
                //Show Error
            }
        })

        
        NetworkManager.sharedInstance.getSportsStories({ (feed: SportsFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feedSportsAll = feedArray.feeds
                
                // Update Cache
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feedSports)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: FeedType.Sports.description)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionViewSports.reloadData()
                })
            }
            else
            {
                //Show Error
            }
        })
        NetworkManager.sharedInstance.getTwitterFeeds({ (feed: TwitterFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.twitterArray = feedArray.feeds
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.twitterArray)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: "TwitterFeeds")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableVIew.reloadData()
                })
            }
            else
            {
                //Show Error
            }
            self.isLoading = false
        })
        
        NetworkManager.sharedInstance.getSocialFeeds({ (feed: SocialFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feedSocial = feedArray.feeds
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feedSocial)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: "SocialFeeds")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadSocialTrends(0)
                })
            }
            else
            {
                //Show Error
            }
            self.isLoading = false
        })

        NetworkManager.sharedInstance.getYoutubeFeeds({ (feed: YoutubeFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feedsYoutube = feedArray.feeds
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feedsYoutube)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: "YoutubeFeeds")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadYoutubeTrends()
                })
            }
            else
            {
                //Show Error
            }
            self.isLoading = false
        })

        NetworkManager.sharedInstance.getTopFeeds({ (feed: TopFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feedsTop3 = feedArray.feeds
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feedsTop3)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: "Top3Feeds")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                })
            }
            else
            {
                //Show Error
            }
            self.isLoading = false
        })
        
    }
    
    // MARK: UICollectionView Delegate for stories
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == collectionViewBusiness
        {
            feedsBusiness = getFilteredFeeds(feedsBusinessAll)
            return feedsBusiness.count
        }
        else if collectionView == collectionViewEntertainment{
            feedEntertainment = getFilteredFeeds(feedEntertainmentAll)
            return feedEntertainment.count;
        }
        else if collectionView == collectionViewLifestyle{
            feedLifeStyle = getFilteredFeeds(feedLifeStyleAll)
            return feedLifeStyle.count
        }
        else if collectionView == collectionViewNews{
            feedNews = getFilteredFeeds(feedNewsAll)
            return feedNews.count
        }
        else{
            feedSports = getFilteredFeeds(feedSportsAll)
            return feedSports.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let identifier = "StoriesCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
        if let storiesCell = cell as? CollectionViewCell
        {
            var feeds:[Feed] = []
            if collectionView == collectionViewBusiness{
                feeds = self.feedsBusiness
            }
            else if collectionView == collectionViewEntertainment{
                feeds = self.feedEntertainment
            }
            
            else if collectionView == collectionViewLifestyle{
                feeds = self.feedLifeStyle
            }
            
            else if collectionView == collectionViewNews{
                feeds = self.feedNews
            }
            
            else{
                feeds = self.feedSports
            }
            
            
            if feeds.count > 0
            {
                let feed: Feed = feeds[indexPath.row]
                storiesCell.articalImage.image = nil
                if let imageURLString = feed.image
                {
                    if let imageURL = NSURL(string: imageURLString) {
                        storiesCell.articalImage.setImageWithURL(imageURL)
                    }
                }
                
                storiesCell.titleLbl.text = feed.title
            }
        }
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let factor = self.interfaceOrientation.isPortrait ? 2 : 3 as CGFloat
            return CGSizeMake((collectionView.bounds.size.width - (10*factor))/factor, collectionView.bounds.size.height-15)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(10, 10, 5, 10)
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath
        indexPath: NSIndexPath) {
            
            
            if let vc: WebVC = self.storyboard?.instantiateViewControllerWithIdentifier("WebVC") as? WebVC {
                
                var feeds:Feed
                if collectionView == collectionViewBusiness{
                    feeds = self.feedsBusiness[indexPath.row]
                }
                else if collectionView == collectionViewEntertainment{
                    feeds = self.feedEntertainment[indexPath.row]
                }
                    
                else if collectionView == collectionViewLifestyle{
                    feeds = self.feedLifeStyle[indexPath.row]
                }
                    
                else if collectionView == collectionViewNews{
                    feeds = self.feedNews[indexPath.row]
                }
                    
                else{
                    feeds = self.feedSports[indexPath.row]
                }
                
                if let urlStr = feeds.link {
                    vc.url = NSURL(string: urlStr)
                }
                
                vc.title = feeds.title
                self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion:nil)
            }
    }
    
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath){
        
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.contentView.backgroundColor = UIColor(red: 124/255.0, green: 162/255.0, blue: 14/255.0, alpha: 0.5)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath){
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.contentView.backgroundColor = nil
    }
    
    
    // MARK: TableViewDelegate for Twitter Trends
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twitterArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseId = "TwitterCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseId)!
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "selected"))
        
        let feed: Feed = twitterArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(21)
        cell.textLabel?.textColor = UIColor(rgba: "#5dff00ff")
        
        cell.textLabel?.text = feed.trends
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let vc: WebVC = self.storyboard?.instantiateViewControllerWithIdentifier("WebVC") as? WebVC {
            let feed: Feed = twitterArray[indexPath.row]
            if let trends = feed.trends {
                var urlStrParams =  trends
                if trends.hasPrefix("#") {
                    urlStrParams = trends.substringFromIndex(trends.startIndex.advancedBy(1))
                }
                vc.url = NSURL(string: "https://twitter.com/search?q="+urlStrParams.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!)
            }
            
            vc.title = feed.trends
            self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion:nil)
        }
    }
    
    
    //MARK: NExt/Prev Action methods
    
    @IBAction func prevPage1(sender: AnyObject) {
        movePage(collectionViewBusiness, direction:.Left)
    }

    @IBAction func nextPage1(sender: AnyObject) {
        movePage(collectionViewBusiness, direction:.Right)
    }
    
    @IBAction func prevPage2(sender: AnyObject) {
        movePage(collectionViewEntertainment, direction:.Left)
    }
    
    @IBAction func nextPage2(sender: AnyObject) {
        movePage(collectionViewEntertainment, direction:.Right)
    }
    
    @IBAction func prevPage3(sender: AnyObject) {
        movePage(collectionViewLifestyle, direction:.Left)
    }
    
    @IBAction func nextPage3(sender: AnyObject) {
        movePage(collectionViewLifestyle, direction:.Right)
    }
    
    @IBAction func prevPage4(sender: AnyObject) {
        movePage(collectionViewNews, direction:.Left)
    }
    
    @IBAction func nextPage4(sender: AnyObject) {
        movePage(collectionViewNews, direction:.Right)
    }
    
    @IBAction func prevPage5(sender: AnyObject) {
        movePage(collectionViewSports, direction:.Left)
    }
    
    @IBAction func nextPage5(sender: AnyObject) {
        movePage(collectionViewSports, direction:.Right)
    }
    
    @IBAction func socialNextBtn(sender: UIButton) {
    }
    
    @IBAction func socialPrevBtn(sender: UIButton) {
    }
    
    func movePage(collectionView:UICollectionView, direction:Direction, isLoop:Bool = false){
        let offset: CGPoint = collectionView.contentOffset
        let pageWidth: CGFloat = collectionView.frame.size.width
        
        let currentPage = floor(offset.x / pageWidth)
        var nextOffset = (currentPage + (direction == .Left ? -1 : 1)) * pageWidth
        if nextOffset > collectionView.contentSize.width - pageWidth {
            if !isLoop {
                nextOffset = collectionView.contentSize.width - pageWidth
            }
            else {
                nextOffset = 0
            }
        }
        else if nextOffset < 0 {
            if !isLoop {
                nextOffset = 0
            }else {
                nextOffset = collectionView.contentSize.width - pageWidth
            }
        }
        
        collectionView.setContentOffset(CGPointMake(nextOffset, 0), animated: true)
    }
    
    //MARK: Animation for Stories
    func update() {
        // Something cool
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.rotateAllStories()
            }, completion: {  (finished: Bool) in
        })
    }
    
    private func rotateAllStories() {
        self.movePage(self.collectionViewBusiness, direction:.Right, isLoop:true)
        self.movePage(self.collectionViewEntertainment, direction:.Right, isLoop:true)
        self.movePage(self.collectionViewLifestyle, direction:.Right, isLoop:true)
        self.movePage(self.collectionViewNews, direction:.Right, isLoop:true)
        self.movePage(self.collectionViewSports, direction:.Right, isLoop:true)
    }
    
    //MARK: Youtube data Load
    private func loadYoutubeTrends(){
        
        for var index = 0; index <  webViews.count; index++ {
            let feed: Feed = feedsYoutube[index]
            
            let currentWebView = webViews[index]
            currentWebView.scrollView.scrollEnabled = false
            if let trend = feed.trends{
                let urlStr = "http://www.youtube.com/embed/\(trend)"
                currentWebView.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)!))
            }
        }
    }
    
    //MARK: social data load
    private func loadSocialTrends(index: Int){
        
        let feed: Feed = feedSocial[index]
        
        socialWebView.scrollView.scrollEnabled = true
        if let htmlCode = feed.htmlCode {
            socialWebView.loadHTMLString(htmlCode, baseURL: NSURL(string: "http://trendingcontent.com"))
        }
    }

    
    //MARK: Top 3 data load
    
    @IBAction func changeActionValue(sender: UIButton) {
         selectedIndex = sender.tag - 201
    }
    
    
    func top3Trends()
    {
        let resultPredicate = NSPredicate(format: "self matches[c] %@", top3Types[selectedIndex])
        let filterFeeds = feedsTop3.filter() {
            let feed = $0 as Feed
            return resultPredicate.evaluateWithObject(feed.kind)
        }
        
        var index = 0
        for feed in filterFeeds
        {
            if index <= 2 {
                let currentImageView = top3Image[index]
                let currentLabel = titleLabel[index]
                let currentArtistLabel = artistLabel[index]
                
                currentImageView.image = nil
                if let imageURLString = feed.image
                {
                    if let imageURL = NSURL(string: imageURLString) {
                        currentImageView.setImageWithURL(imageURL)
                    }
                }
                currentLabel.text = feed.title
                currentArtistLabel.text = feed.artist
                
                index++
            }
        }
    }
    
    
    //MARK: Footer Link
    @IBAction func privacyPolicy(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://trendingcontent.com")!)
    }
    
    @IBAction func termsOfServices(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://trendingcontent.com")!)
    }
    
    @IBAction func mailButton(sender: AnyObject) {
        let url = NSURL(string: "mailto:info@mmibroadcasting.com")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func facebookButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/trendingcontent")!)
    }
    

    //MARK: Search Realted methods
    
    @IBAction func searchBarButton(sender: UIButton) {
        
        if !searchBtnClicked
        {
            searchBtnClicked = true;
            searchTextField.text = ""
            
            UIView.animateWithDuration(0.5, animations: {
                var rect = self.searchTextField.frame
                rect.origin.x = rect.origin.x - 271
                rect.size.width = 271
                self.searchTextField.frame = rect
                }, completion: { (finished: Bool) in
                    
            })
        }
        else
        {
            UIView.animateWithDuration(0.5, animations: {
                var rect = self.searchTextField.frame
                rect.origin.x = rect.origin.x + 271
                rect.size.width = 0
                self.searchTextField.frame = rect
                }, completion: { (finished: Bool) in
                    self.searchTextField.text = ""
            })
            searchBtnClicked = false;
        }
    }
    
    private func searchStories(string: String?){
        _searchText = string
        
        self.collectionViewBusiness.reloadData()
        self.collectionViewEntertainment.reloadData()
        self.collectionViewLifestyle.reloadData()
        self.collectionViewNews.reloadData()
        self.collectionViewSports.reloadData()
    }
    
    private func getFilteredFeeds(feeds: [Feed]) -> [Feed] {
        
        var filterFeeds = feeds
        if _searchText?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
        {
            let resultPredicate = NSPredicate(format: "self contains[cd] %@", _searchText!)
            filterFeeds = feeds.filter() {
                let feed = $0 as Feed
                return resultPredicate.evaluateWithObject(feed.title)
            }
        }
        
        return filterFeeds
    }
    
    //MARK: TextField Delegate 
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string) as String?
        searchStories(searchText)
        
        return true
    }
}

