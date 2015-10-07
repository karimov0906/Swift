//
//  StoriesVC.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 19/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit


class CoverFlowVC: BaseVC {
    
    private var isLoading: Bool
    private var feeds: [Feed] = []
    @IBOutlet weak var carousel: iCarousel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        isLoading = false
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        isLoading = false
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        carousel.type = iCarouselType.Cylinder
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let data: NSData = CacheManager.sharedCachedManager.cacheData("CoverFlow") as? NSData {
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
        isLoading  = true
    }
    
    // MARK: TableViewDelegate
    
    private func reloadData() {
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return self.feeds.count
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView! {
        let feed = self.feeds[index]
        let carouselCell : iCarouselCell = (view as? iCarouselCell) ?? self.cellForCarousel(carousel)
        carouselCell.setImage(nil, imageURL: feed.image)
        return carouselCell
    }
    
    
    func cellForCarousel(carousel : iCarousel) ->  iCarouselCell  {
        return iCarouselCell(frame: carousel.bounds)
    }
    
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch(option) {
        case .Wrap:
            return 1.0
        default:
            return value
        }
    }
    
    
    func scrollCarouselToIndex(int : Int, animated : Bool) {
        carousel?.scrollToItemAtIndex(int, animated: animated)
    }
}

class iCarouselCell : UIView {
    var imageView : UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addImageView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        self.addImageView()
    }
    
    func addImageView() {
        imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView!)
    }
    
    func setImage(image : UIImage? = nil, imageURL : String? = nil) {
        
        if let _imageView = imageView {
            
            if let _ = image {
                _imageView.image = image
            }
            
            if let _imageURL = imageURL {
                if let url = NSURL(string: _imageURL) {
                    _imageView.setImageWithURL(url)
                }
            }
        }
        else {
            print("Warning : Can not set Image with NIL ImageView. Please set ImageView manually or use init(frame:) method")
        }
    }
}

