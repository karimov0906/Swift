//
//  CacheManager.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 22/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import Foundation

class CacheManager {
    static let sharedCachedManager = CacheManager()
    private static let kDefaultTimeInterval:NSTimeInterval = 60*60*24
    init()
    {
        
    }
    
    func saveCacheData(data: AnyObject?, identifier: String, timeInterval: NSTimeInterval = kDefaultTimeInterval) {
        let defaults: NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        if data != nil {
            defaults?.setObject(data, forKey: dataKeyForIdentifier(identifier))
        }
        defaults?.setObject(NSDate(), forKey: lastUsageKeyForIdentifier(identifier))
        defaults?.setDouble(timeInterval, forKey: timeIntervalKeyForIdentifier(identifier))
        defaults?.synchronize()
    }
    
    func cacheData(identifier: String) -> AnyObject? {
        let defaults: NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        return defaults?.objectForKey(dataKeyForIdentifier(identifier))
    }
    
    func timeInterval(identifier: String) -> NSTimeInterval? {
        let defaults: NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        return defaults?.doubleForKey(timeIntervalKeyForIdentifier(identifier))
    }
    
    func isCacheTimedout(identifier: String) -> Bool {
        let defaults: NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        let lastUsage: NSDate? = defaults?.objectForKey(lastUsageKeyForIdentifier(identifier)) as? NSDate
        let timeInterval = self.timeInterval(identifier)
        
        let referenceDate: NSDate = NSDate(timeIntervalSinceNow: -(timeInterval!))
        return lastUsage?.compare(referenceDate) == NSComparisonResult.OrderedAscending
    }
    
    private func dataKeyForIdentifier(identifier: String) -> String {
        return "\(identifier)_Data"
    }
    
    private func lastUsageKeyForIdentifier(identifier: String) -> String {
        return "\(identifier)_LastUsage"
    }
    
    private func timeIntervalKeyForIdentifier(identifier: String) -> String {
        return "\(identifier)_MaxAge"
    }
    
}