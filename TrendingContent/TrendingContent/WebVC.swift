//
//  WebVC.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 19/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

class WebVC: UIViewController, UIWebViewDelegate  {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnForward: UIBarButtonItem!
    @IBOutlet weak var btnBackward: UIBarButtonItem!
    var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(url != nil)
        {
            
            let request = NSURLRequest(URL: url!)
            
            webView.delegate = self
            
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            webView.loadRequest(request)

        }
        
        btnForward.enabled = webView.canGoForward
        btnBackward.enabled = webView.canGoBack
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
//        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad)
//        {
//            self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 44)
//        }
//        else
//        {
//            self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0 - 44)
//        }
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0 - 44)


    }
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
        }
        
//        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad)
//        {
//            self.webView.frame = CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44)
//        }
//        else
//        {
//            self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0 - 44)
//        }
        
        
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0 - 44)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
        btnForward.enabled = webView.canGoForward
        btnBackward.enabled = webView.canGoBack
    }
    
    @IBAction func doRefresh(_: AnyObject) {
        webView.reload()
    }
    
    @IBAction func goBack(_: AnyObject) {
        webView.goBack()
        btnForward.enabled = webView.canGoForward
        btnBackward.enabled = webView.canGoBack
    }
    
    @IBAction func goForward(_: AnyObject) {
        webView.goForward()
        btnForward.enabled = webView.canGoForward
        btnBackward.enabled = webView.canGoBack
    }
    
    @IBAction func stop(_: AnyObject) {
        webView.stopLoading()
    }

    // dismiss webVC
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

