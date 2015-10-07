//
//  StoriesVC.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 19/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit


// MARK: Enum for Feed Type
enum FeedType : CustomStringConvertible{
    case None, Business, Entertainment, LifeStyle, News, Sports
    
    var description : String {
        switch self {
            case .None: return "None";
            case .Business: return "Business";
            case .Entertainment: return "Entertainment";
            case .LifeStyle: return "LifeStyle";
            case .News: return "News";
            case .Sports: return "Sports";
        }
    }
}

// MARK: StoriesVC Class
class StoriesVC: BaseTableVC {
    
    // MARK: Properties
    var feedType: FeedType
    
    // MARK: Priavte variables
    private var isLoading: Bool
    private var feeds: [Feed] = []
    private var filterFeeds: [Feed] = []
    private var _searchText: String?
    
    // MARK: Init Methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        feedType = FeedType.None
        isLoading = false
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        feedType = FeedType.None
        isLoading = false
        
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set Table Footer to remove additional lines
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get data from cache
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(self.feedType.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feeds = cachedFeeds
                self.reloadData()
            }
        }
        
        // Make Request to get updated feeds
        makeRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: API Request
    
    private func makeRequest()
    {
        isLoading  = true
        switch feedType {
        
            // Business feed type
        case .Business:
            // API call
            NetworkManager.sharedInstance.getBusinessStories({ (feed: BusinessFeeds?, err: NSError?) -> Void in
                if let feedArray = feed {
                    self.feeds = feedArray.feeds
                    
                    // Update Cache
                    let data = NSKeyedArchiver.archivedDataWithRootObject(self.feeds)
                    CacheManager.sharedCachedManager.saveCacheData(data, identifier: self.feedType.description)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.reloadData()
                    })
                }
                else
                {
                    //Show Error
                }
                self.isLoading  = false
            })
            
            // Entertainment feed type
        case .Entertainment:
            NetworkManager.sharedInstance.getEntertainmentStories({ (feed: EntertainmentFeeds?, err: NSError?) -> Void in
                if let feedArray = feed {
                    self.feeds = feedArray.feeds
                    
                    // Update Cache
                    let data = NSKeyedArchiver.archivedDataWithRootObject(self.feeds)
                    CacheManager.sharedCachedManager.saveCacheData(data, identifier: self.feedType.description)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.reloadData()
                    })
                }
                else
                {
                    //Show Error
                }
                self.isLoading  = false
            })
            
            // LifeStyle feed type
        case .LifeStyle:
            NetworkManager.sharedInstance.getLifestyleStories({ (feed: LifestyleFeeds?, err: NSError?) -> Void in
                if let feedArray = feed {
                    self.feeds = feedArray.feeds
                    
                    // Update Cache
                    let data = NSKeyedArchiver.archivedDataWithRootObject(self.feeds)
                    CacheManager.sharedCachedManager.saveCacheData(data, identifier: self.feedType.description)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.reloadData()
                    })
                }
                else
                {
                    //Show Error
                }
                self.isLoading  = false
            })
            
            // News feed type
        case .News:
            NetworkManager.sharedInstance.getNewsStories({ (feed: NewsFeeds?, err: NSError?) -> Void in
                if let feedArray = feed {
                    self.feeds = feedArray.feeds
                    
                    // Update Cache
                    let data = NSKeyedArchiver.archivedDataWithRootObject(self.feeds)
                    CacheManager.sharedCachedManager.saveCacheData(data, identifier: self.feedType.description)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.reloadData()
                    })
                }
                else
                {
                    //Show Error
                }
                self.isLoading  = false
            })
            
            // Sports feed type
        case .Sports:
            NetworkManager.sharedInstance.getSportsStories({ (feed: SportsFeeds?, err: NSError?) -> Void in
                if let feedArray = feed {
                    self.feeds = feedArray.feeds
                    
                    // Update Cache
                    let data = NSKeyedArchiver.archivedDataWithRootObject(self.feeds)
                    CacheManager.sharedCachedManager.saveCacheData(data, identifier: self.feedType.description)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.reloadData()
                    })
                }
                else
                {
                    //Show Error
                }
                self.isLoading  = false
            })
            
        default:
            print("Wrong Value of feedtype")
        }
    }
    
    // MARK: Reload table with filter search
    private func reloadData() {
        
        // Search text in update data
        searchText(_searchText)
        
        // Notify data availablity
        self.notifyForDataAvailability()
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // setup Cell
        let reuseId = "StoriesCell"
        let cell: StoriesCell = tableView.dequeueReusableCellWithIdentifier(reuseId) as! StoriesCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "selected"))
        
        //
        let feed: Feed = filterFeeds[indexPath.row]
        
        cell.articleImageview.image = nil
        if let imageURLString = feed.image
        {
            if let imageURL = NSURL(string: imageURLString) {
                cell.articleImageview.setImageWithURL(imageURL)
            }
        }
        
        cell.titleLabel.text = feed.title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterFeeds.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let vc: WebVC = self.storyboard?.instantiateViewControllerWithIdentifier("WebVC") as? WebVC {
            let feed: Feed = filterFeeds[indexPath.row]
            if let urlStr = feed.link {
                vc.url = NSURL(string: urlStr)
            }
            
            vc.title = feed.title
            self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion:nil)
        }
    }
    
    override func searchText(string: String?)
    {
        _searchText = string
        if string?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
        {
            let resultPredicate = NSPredicate(format: "self contains[cd] %@", string!)
            filterFeeds = feeds.filter() {
                let feed = $0 as Feed
                return resultPredicate.evaluateWithObject(feed.title)
            }
        }
        else
        {
            filterFeeds = feeds
        }
        
        tableView.reloadData()
    }
}

