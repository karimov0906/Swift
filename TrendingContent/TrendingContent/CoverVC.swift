//
//  StoriesVC.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 19/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

enum RedirectionType : String{
    case All = "All"
    case Business = "Business"
    case Entertainment = "Entertainment"
    case LifeStyle = "LifeStyle"
    case News = "News"
    case Sports = "Sports"
    case Top = "Top"
}


class CoverVC: BaseCollectionVC {
    private var feeds: [AnyObject?] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reloadData()
        NSNotificationCenter.defaultCenter().addObserverForName(kDataAvailableNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            self.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: CollectionViewDelegate
    
    private func reloadData() {
        self.feeds = []
        
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.Business.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                if cachedFeeds.count > 0 {
                    let info = ["Title":"Business", "Redirection":RedirectionType.Business.rawValue, "Feeds": cachedFeeds]
                    self.feeds.append(info)
                }
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.Entertainment.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                if cachedFeeds.count > 0 {
                    let info = ["Title":"Entertainment", "Redirection":RedirectionType.Entertainment.rawValue, "Feeds": cachedFeeds]
                    self.feeds.append(info)
                }
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.LifeStyle.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                if cachedFeeds.count > 0 {
                    let info = ["Title":"LifeStyle", "Redirection":RedirectionType.LifeStyle.rawValue, "Feeds": cachedFeeds]
                    self.feeds.append(info)
                }
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.News.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                if cachedFeeds.count > 0 {
                    let info = ["Title":"News", "Redirection":RedirectionType.News.rawValue, "Feeds": cachedFeeds]
                    self.feeds.append(info)
                }
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData(FeedType.Sports.description) as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                if cachedFeeds.count > 0 {
                    let info = ["Title":"Sports", "Redirection":RedirectionType.Sports.rawValue, "Feeds": cachedFeeds]
                    self.feeds.append(info)
                }
            }
        }
        
        if let data: NSData = CacheManager.sharedCachedManager.cacheData("Top3Feeds") as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                if cachedFeeds.count > 0 {
                    let resultPredicate = NSPredicate(format: "self matches[c] %@", "songs")
                    let filterFeeds = cachedFeeds.filter() {
                        let feed = $0 as Feed
                        return resultPredicate.evaluateWithObject(feed.kind)
                    }
                    if filterFeeds.count > 0 {
                        let info = ["Title":"Top Songs", "Redirection":RedirectionType.Top.rawValue, "Feeds": filterFeeds]
                        self.feeds.append(info)
                    }
                }
            }
        }
        
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CoverCell", forIndexPath: indexPath) as? CoverCell {
            let info:[String:AnyObject] = feeds[indexPath.row] as! [String:AnyObject]
            
            cell.sectionLabel.text = info["Title"] as? String
            cell.feeds = info["Feeds"] as? [Feed] ?? []
            
            return cell
        }
        else {
            return collectionView.dequeueReusableCellWithReuseIdentifier("CoverCell", forIndexPath: indexPath)
        }
    }

    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:(collectionView.bounds.size.width-30)/2, height: (collectionView.bounds.size.width-30)/2)
    }
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAtIndex indexPath: NSIndexPath) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let info:[String:AnyObject] = feeds[indexPath.row] as! [String:AnyObject]
        if let redirectionStr = info["Redirection"] as? String {
            if let type:RedirectionType = RedirectionType(rawValue: redirectionStr) {
                switch(type) {
                case .Business:
                    slidingViewController?.setCurrentViewControllerAtIndex(2)
                case .Entertainment:
                    slidingViewController?.setCurrentViewControllerAtIndex(3)
                case .LifeStyle:
                    slidingViewController?.setCurrentViewControllerAtIndex(4)
                case .News:
                    slidingViewController?.setCurrentViewControllerAtIndex(5)
                case .Sports:
                    slidingViewController?.setCurrentViewControllerAtIndex(6)
                case .Top:
                    slidingViewController?.setCurrentViewControllerAtIndex(9)
                default:
                    print("wrong type")
                }
            }
        }
    }
}
