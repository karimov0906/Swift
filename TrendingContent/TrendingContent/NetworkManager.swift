//
//  NetworkManager.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 20/06/15.
//  Copyright (c) 2015 mmibroadcasting. All rights reserved.
//

import Foundation

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    init()
    {
    }
    
    func getBusinessStories(completionHandler: ((BusinessFeeds?, NSError?) -> Void)?)
    {
        let request = HTTPTask()
        request.baseURL = "http://trendingcontent.com/api/v1.0"
        request.responseSerializer = JSONResponseSerializer()
        request.GET("/feeds/Business", parameters: nil, completionHandler: { (response: HTTPResponse) -> Void in
            if let err = response.error {
                print("error: \(err.debugDescription)")
                if let handler = completionHandler{
                    handler(nil, err)
                }
            }
            else
            {
                if let responseObject: AnyObject = response.responseObject {
                    let feeds = BusinessFeeds(JSONDecoder(responseObject))
                    if let handler = completionHandler{
                        handler(feeds, nil)
                    }
                }
            }
        })
    }
    
    func getEntertainmentStories(completionHandler: ((EntertainmentFeeds?, NSError?) -> Void)?)
    {
        let request = HTTPTask()
        request.baseURL = "http://trendingcontent.com/api/v1.0"
        request.responseSerializer = JSONResponseSerializer()
        request.GET("/feeds/Entertainment", parameters: nil, completionHandler: { (response: HTTPResponse) -> Void in
            if let err = response.error {
                print("error: \(err.debugDescription)")
                if let handler = completionHandler{
                    handler(nil, err)
                }
            }
            else
            {
                if let responseObject: AnyObject = response.responseObject {
                    let feeds = EntertainmentFeeds(JSONDecoder(responseObject))
                    if let handler = completionHandler{
                        handler(feeds, nil)
                    }
                }
            }
        })
    }
    
    func getLifestyleStories(completionHandler: ((LifestyleFeeds?, NSError?) -> Void)?)
    {
        let request = HTTPTask()
        request.baseURL = "http://trendingcontent.com/api/v1.0"
        request.responseSerializer = JSONResponseSerializer()
        request.GET("/feeds/Lifestyle", parameters: nil, completionHandler: { (response: HTTPResponse) -> Void in
            if let err = response.error {
                print("error: \(err.debugDescription)")
                if let handler = completionHandler{
                    handler(nil, err)
                }
            }
            else
            {
                if let responseObject: AnyObject = response.responseObject {
                    let feeds = LifestyleFeeds(JSONDecoder(responseObject))
                    if let handler = completionHandler{
                        handler(feeds, nil)
                    }
                }
            }
        })
    }
    
    func getNewsStories(completionHandler: ((NewsFeeds?, NSError?) -> Void)?)
    {
        let request = HTTPTask()
        request.baseURL = "http://trendingcontent.com/api/v1.0"
        request.responseSerializer = JSONResponseSerializer()
        request.GET("/feeds/News", parameters: nil, completionHandler: { (response: HTTPResponse) -> Void in
            if let err = response.error {
                print("error: \(err.debugDescription)")
                if let handler = completionHandler{
                    handler(nil, err)
                }
            }
            else
            {
                if let responseObject: AnyObject = response.responseObject {
                    let feeds = NewsFeeds(JSONDecoder(responseObject))
                    if let handler = completionHandler{
                        handler(feeds, nil)
                    }
                }
            }
        })
    }
    
    func getSportsStories(completionHandler: ((SportsFeeds?, NSError?) -> Void)?)
    {
        let request = HTTPTask()
        request.baseURL = "http://trendingcontent.com/api/v1.0"
        request.responseSerializer = JSONResponseSerializer()
        request.GET("/feeds/Sports", parameters: nil, completionHandler: { (response: HTTPResponse) -> Void in
            if let err = response.error {
                print("error: \(err.debugDescription)")
                if let handler = completionHandler{
                    handler(nil, err)
                }
            }
            else
            {
                if let responseObject: AnyObject = response.responseObject {
                    let feeds = SportsFeeds(JSONDecoder(responseObject))
                    if let handler = completionHandler{
                        handler(feeds, nil)
                    }
                }
            }
        })
    }
    
    func getTwitterFeeds(completionHandler: ((TwitterFeeds?, NSError?) -> Void)?)
    {
        let request = HTTPTask()
        request.baseURL = "http://trendingcontent.com/api/v1.0"
        request.responseSerializer = JSONResponseSerializer()
        request.GET("/get-twitter-trends/", parameters: nil, completionHandler: { (response: HTTPResponse) -> Void in
            if let err = response.error {
                print("error: \(err.debugDescription)")
                if let handler = completionHandler{
                    handler(nil, err)
                }
            }
            else
            {
                if let responseObject: AnyObject = response.responseObject {
                    let feeds = TwitterFeeds(JSONDecoder(responseObject))
                    if let handler = completionHandler{
                        handler(feeds, nil)
                    }
                }
            }
        })
    }
    
    func getYoutubeFeeds(completionHandler: ((YoutubeFeeds?, NSError?) -> Void)?)
    {
        let request = HTTPTask()
        request.baseURL = "http://trendingcontent.com/api/v1.0"
        request.responseSerializer = JSONResponseSerializer()
        request.GET("/get-youtube-trends/", parameters: nil, completionHandler: { (response: HTTPResponse) -> Void in
            if let err = response.error {
                print("error: \(err.debugDescription)")
                if let handler = completionHandler{
                    handler(nil, err)
                }
            }
            else
            {
                if let responseObject: AnyObject = response.responseObject {
                    let feeds = YoutubeFeeds(JSONDecoder(responseObject))
                    if let handler = completionHandler{
                        handler(feeds, nil)
                    }
                }
            }
        })
    }
    
    func getSocialFeeds(completionHandler: ((SocialFeeds?, NSError?) -> Void)?)
    {
        let request = HTTPTask()
        request.baseURL = "http://trendingcontent.com/api/v1.0"
        request.responseSerializer = JSONResponseSerializer()
        request.GET("/get-social/", parameters: nil, completionHandler: { (response: HTTPResponse) -> Void in
            if let err = response.error {
                print("error: \(err.debugDescription)")
                if let handler = completionHandler{
                    handler(nil, err)
                }
            }
            else
            {
                if let responseObject: AnyObject = response.responseObject {
                    let feeds = SocialFeeds(JSONDecoder(responseObject))
                    if let handler = completionHandler{
                        handler(feeds, nil)
                    }
                }
            }
        })
    }
    
    func getTopFeeds(completionHandler: ((TopFeeds?, NSError?) -> Void)?)
    {
        let request = HTTPTask()
        request.baseURL = "http://trendingcontent.com/api/v1.0"
        request.responseSerializer = JSONResponseSerializer()
        request.GET("/get-top3-trends/", parameters: nil, completionHandler: { (response: HTTPResponse) -> Void in
            if let err = response.error {
                print("error: \(err.debugDescription)")
                if let handler = completionHandler{
                    handler(nil, err)
                }
            }
            else
            {
                if let responseObject: AnyObject = response.responseObject {
                    let feeds = TopFeeds(JSONDecoder(responseObject))
                    if let handler = completionHandler{
                        handler(feeds, nil)
                    }
                }
            }
        })
    }
}

