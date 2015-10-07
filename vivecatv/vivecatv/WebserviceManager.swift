//
//  WebserviceManager.swift
//  vivecatv
//
//  Created by Solar Jang on 9/19/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import Foundation

enum WEBSERVICE_API{
    case YEAR_LIST,
    MUSIC_LIST,
    ENTERTAINMENT_LIST,
    ADVERTISEMENT_LIST
}

protocol WebserviceManagerDelegate{
    
    func GetMusicVideosByYearHandler(musicList:NSDictionary)
    func GetEntertainmentVideosByYearHandler(entertainmentList:NSDictionary)
    func didDownloadAdvertisementList(advertisementList:NSDictionary)
    func GetYearListHandler(yearList:NSDictionary)
    func diFailwebservice()
}

extension WebserviceManagerDelegate
{
    
}

let GET_YEAR = NSURL(string: "http://vivecatv.com/api/v1.0/get-yearlist/")
let GET_MUSIC = NSURL(string: "http://vivecatv.com/api/v1.0/get-mediatype-music/")
let GET_ENTERTAINMENT = NSURL(string: "http://vivecatv.com/api/v1.0/get-mediatype-entertainment/")
let GET_ADVERSTISEMENT = NSURL(string: "http://vivecatv.com/api/v1.0/get-mediatype-adverts/")

class WebserviceManager: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    var receivedData:NSMutableData = NSMutableData()
    var requestedService:WEBSERVICE_API?
    
    var httpConnection:NSURLConnection?
    var delegate:WebserviceManagerDelegate?
    
    func getYearsList()
    {
        self.requestedService = WEBSERVICE_API.YEAR_LIST
        let type = "music"
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: GET_YEAR!)
        request.HTTPMethod = "POST"
        let bodyString:NSString = "type=\(type)"
        
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
//        self.httpConnection = NSURLConnection(request: request, delegate: self)
        
        let configuration =
        NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration,
            delegate: self,
            delegateQueue:NSOperationQueue.mainQueue())
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            
            // your code
            if error != nil {
                //error
                print(error!.description)
                
            } else {
//                let result = NSString(data: data!, encoding:
//                    NSASCIIStringEncoding)!
                
                do{
                    
                    let dic:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//                    if let val = self.delegate?.GetMusicVideosByYearHandler(dic)
//                    {
//                        print(val)
                    
                        self.delegate?.GetYearListHandler(dic);
//                    }
                    //success
                    print(dic);
                
                }catch{
                    
                }
                
            }
            
        });
        
        task.resume()
        
    }
    func getMusicList(year:String)
    {
        self.requestedService = WEBSERVICE_API.MUSIC_LIST
//        let type = "year"
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: GET_MUSIC!)
        request.HTTPMethod = "POST"
        let bodyString:NSString = "year=\(year)"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        //        self.httpConnection = NSURLConnection(request: request, delegate: self)
        
        let configuration =
        NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration,
            delegate: self,
            delegateQueue:NSOperationQueue.mainQueue())
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            
            // your code
            if error != nil {
                //error
                print(error!.description)
                
            } else {
                //                let result = NSString(data: data!, encoding:
                //                    NSASCIIStringEncoding)!
                
                do{
                    
                    let dic:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    
//                    if let val = self.delegate?.GetMusicVideosByYearHandler(dic)
//                    {
//                        print(val)
                    
                        self.delegate?.GetMusicVideosByYearHandler(dic)
//                    }
                    //success
                    print(dic);
                    
                }catch{
                    
                }
                
            }
            
        });
        
        task.resume()
    }
    func getEntertainmentList(year:String)
    {
        self.requestedService = WEBSERVICE_API.ENTERTAINMENT_LIST
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: GET_ENTERTAINMENT!)
        request.HTTPMethod = "POST"
        let bodyString:NSString = "year=\(year)"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        //        self.httpConnection = NSURLConnection(request: request, delegate: self)
        
        let configuration =
        NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration,
            delegate: self,
            delegateQueue:NSOperationQueue.mainQueue())
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            
            // your code
            if error != nil {
                //error
                print(error!.description)
                
            } else {
                //                let result = NSString(data: data!, encoding:
                //                    NSASCIIStringEncoding)!
                
                do{
                    
                    let dic:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//                    if let val = self.delegate?.GetEntertainmentVideosByYearHandler(dic)
//                    {
//                        print(val)
                    
                        self.delegate?.GetEntertainmentVideosByYearHandler(dic);
//                    }
                    //success
                    print(dic);
                    
                }catch{
                    
                }
                
            }
            
        });
        
        task.resume()
    }
    func getAdvertisement()
    {
        self.requestedService = WEBSERVICE_API.ADVERTISEMENT_LIST
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: GET_ADVERSTISEMENT!)
        request.HTTPMethod = "GET"
        
        let configuration =
        NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration,
            delegate: self,
            delegateQueue:NSOperationQueue.mainQueue())
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            
            // your code
            if error != nil {
                //error
                print(error!.description)
                
            } else {
                
                do{
                    
                    let dic:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//                    if let val = self.delegate?.didDownloadAdvertisementList(dic)
//                    {
//                        print(val)
//                    }
                    
                    self.delegate?.didDownloadAdvertisementList(dic)
                    
                    //success
                    print(dic);
                    
                }catch{
                    
                }
                
            }
            
        });
        
        task.resume()
    }
    
    
}

