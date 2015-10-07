//
//  TwitterVC.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 23/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

class Top3VC: BaseTableVC {
    private var isLoading: Bool
    private var feeds: [Feed] = []
    private var filterFeeds: [Feed] = []
    private var _searchText: String?
    private var selectedIndex: Int = 0
    private var types :[String] = ["songs","movies","episodes","apps","books"]
    
    @IBOutlet var segmentControl: UISegmentedControl!
    
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
        tableView.tableHeaderView = segmentControl
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //segmentControl.selectedSegmentIndex = selectedIndex
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let data: NSData = CacheManager.sharedCachedManager.cacheData("Top3Feeds") as? NSData {
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
        NetworkManager.sharedInstance.getTopFeeds({ (feed: TopFeeds?, err: NSError?) -> Void in
            if let feedArray = feed {
                self.feeds = feedArray.feeds
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(self.feeds)
                CacheManager.sharedCachedManager.saveCacheData(data, identifier: "Top3Feeds")
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
        //searchText(_searchText)
        filter()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseId = "Top3Cell"
        let cell: Top3Cell = tableView.dequeueReusableCellWithIdentifier(reuseId) as! Top3Cell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "selected"))
        
        let feed: Feed = filterFeeds[indexPath.row]
        
        cell.artworkImageview.image = nil
        if let imageURLString = feed.image
        {
            if let imageURL = NSURL(string: imageURLString) {
                cell.artworkImageview.setImageWithURL(imageURL)
            }
        }
        
        cell.posLabel.text = "\(indexPath.row+1)"
        cell.titleLabel.text = feed.title
        cell.artistLabel.text = feed.artist
        
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
    
    func filter()
    {
        let resultPredicate = NSPredicate(format: "self matches[c] %@", types[selectedIndex])
        filterFeeds = feeds.filter() {
            let feed = $0 as Feed
            return resultPredicate.evaluateWithObject(feed.kind)
        }
        tableView.reloadData()
    }
    
    //MARK: IBACTION Method
    @IBAction func changeSegmentValue(sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
        filter()
    }
}
