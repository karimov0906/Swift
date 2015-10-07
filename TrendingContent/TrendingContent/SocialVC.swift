//
//  TwitterVC.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 23/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

class SocialVC: BaseTableVC {
    private var isLoading: Bool
    private var feeds: [Feed] = []
    private var filterFeeds: [Feed] = []
    private var _searchText: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        isLoading = false
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        isLoading = false
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let data: NSData = CacheManager.sharedCachedManager.cacheData("SocialFeeds") as? NSData {
            if let cachedFeeds = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Feed] {
                self.feeds = cachedFeeds
                self.reloadData()
            }
        }
        makeRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Request
    
    private func makeRequest()
    {
        self.isLoading = true
        NetworkManager.sharedInstance.getSocialFeeds({ (feed: SocialFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feeds = feedArray.feeds
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feeds)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: "SocialFeeds")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.reloadData()
                })
            }
            else
            {
                //Show Error
            }
            self.isLoading = false
        })
    }
    
    // MARK: TableViewDelegate
    
    private func reloadData() {
        searchText(_searchText)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseId = "SocialCell"
        let cell: WebViewCell = tableView.dequeueReusableCellWithIdentifier(reuseId) as! WebViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "selected"))
        
        let feed: Feed = filterFeeds[indexPath.row]
        
//        cell.webView.scrollView.scrollEnabled = false
        if let htmlCode = feed.htmlCode {
            cell.webView.loadHTMLString(htmlCode, baseURL: NSURL(string: "http://trendingcontent.com"))
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterFeeds.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func shouldSearchAvailble() -> Bool {
        return false
    }
    
    override func searchText(string: String?)
    {
        _searchText = string
        if string?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
        {
            let resultPredicate = NSPredicate(format: "self contains[cd] %@", string!)
            filterFeeds = feeds.filter() {
                let feed = $0 as Feed
                return resultPredicate.evaluateWithObject(feed.trends)
            }
        }
        else
        {
            filterFeeds = feeds
        }
        
        tableView.reloadData()
    }
}
