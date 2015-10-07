//
//  BaseVC.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 23/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

// MARK: Notification for Data Avalablity
let kDataAvailableNotification = "DataAvailableNotification"

// MARK: Base class for UITableViewController
class BaseTableVC: UITableViewController, SearchProtocol {
    
    // MARK: Properties
    var slidingViewController:SlidingContainerViewController?  = nil
    
    // MARK: SearchProtocol Implementation
    
    func searchText(string: String?) {
        
    }
    
    func shouldSearchAvailble() -> Bool {
        return true
    }
    
    // MARK: Method to notifty data Availability
    
    func notifyForDataAvailability(params: AnyObject? = nil) {
        if let info = params {
            NSNotificationCenter.defaultCenter().postNotificationName(kDataAvailableNotification, object: NSStringFromClass(self.dynamicType), userInfo: ["params" : info])
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName(kDataAvailableNotification, object: NSStringFromClass(self.dynamicType))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.blackColor()
    }
}

// MARK: Base class for UIViewController

class BaseVC: UIViewController {
    // MARK: Properties
    var slidingViewController:SlidingContainerViewController?  = nil
    
    // MARK: Method to notifty data Availability
    
    func notifyForDataAvailability(params: AnyObject? = nil) {
        if let info = params {
            NSNotificationCenter.defaultCenter().postNotificationName(kDataAvailableNotification, object: NSStringFromClass(self.dynamicType), userInfo: ["params" : info])
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName(kDataAvailableNotification, object: NSStringFromClass(self.dynamicType))
        }
    }
}

// MARK: Base class for UICollectionViewController

class BaseCollectionVC: UICollectionViewController {
    // MARK: Properties
    var slidingViewController:SlidingContainerViewController?  = nil
    
    // MARK: Method to notifty data Availability
    
    func notifyForDataAvailability(params: AnyObject? = nil) {
        if let info = params {
            NSNotificationCenter.defaultCenter().postNotificationName(kDataAvailableNotification, object: NSStringFromClass(self.dynamicType), userInfo: ["params" : info])
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName(kDataAvailableNotification, object: NSStringFromClass(self.dynamicType))
        }
    }
}
