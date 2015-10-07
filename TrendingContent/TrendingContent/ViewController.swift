//
//  ViewController.swift
//  TrendingContent
//
//  Created by Prakash Gupta on 19/06/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

// MARK: Protocol for Serach implemnetation
protocol SearchProtocol{
    func searchText(string: String?)
    func shouldSearchAvailble() -> Bool
}

// MARK: Initial/Root View Controller
class ViewController: UIViewController, SlidingContainerViewControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Private varibales
    private var slidingContainerViewController: SlidingContainerViewController!
    private var isSearchEnabled: Bool = false {
        didSet {
            searchBar.hidden = !isSearchEnabled
            if isSearchEnabled{
                searchBar.becomeFirstResponder()
            }
        }
    }
    private var searchText: String?, lastSearchText: String?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        searchBar.hidden = !isSearchEnabled
        
        // Instantiate All Child View Controllers
        let coverVC: CoverVC = self.storyboard?.instantiateViewControllerWithIdentifier("CoverVC") as! CoverVC
        
        let businessVC: StoriesVC = self.storyboard?.instantiateViewControllerWithIdentifier("StoriesVC") as! StoriesVC
        businessVC.feedType = FeedType.Business
        
        let entertainmentVC: StoriesVC = self.storyboard?.instantiateViewControllerWithIdentifier("StoriesVC") as! StoriesVC
        entertainmentVC.feedType = FeedType.Entertainment
        
        let lifestyleVC: StoriesVC = self.storyboard?.instantiateViewControllerWithIdentifier("StoriesVC") as! StoriesVC
        lifestyleVC.feedType = FeedType.LifeStyle
        
        let newsVC: StoriesVC = self.storyboard?.instantiateViewControllerWithIdentifier("StoriesVC") as! StoriesVC
        newsVC.feedType = FeedType.News
        
        let sportsVC: StoriesVC = self.storyboard?.instantiateViewControllerWithIdentifier("StoriesVC") as! StoriesVC
        sportsVC.feedType = FeedType.Sports
        
        let twitterVC: TwitterVC = self.storyboard?.instantiateViewControllerWithIdentifier("TwitterVC") as! TwitterVC
        
        let youtubeVC: YoutubeVC = self.storyboard?.instantiateViewControllerWithIdentifier("YoutubeVC") as! YoutubeVC
        
        let socialVC: SocialVC = self.storyboard?.instantiateViewControllerWithIdentifier("SocialVC") as! SocialVC
        
        let top3VC: Top3VC = self.storyboard?.instantiateViewControllerWithIdentifier("Top3VC") as! Top3VC
        
        // Set up Slider View Controller
        slidingContainerViewController = SlidingContainerViewController(parent: self, contentViewControllers: [coverVC, socialVC, businessVC, entertainmentVC, lifestyleVC, newsVC, sportsVC, twitterVC, youtubeVC, top3VC], titles: ["All", "Social", "Business", "Entertainment", "LifeStyle", "News", "Sports", "Twitter", "Youtube", "Top 3"])
        slidingContainerViewController.delegate = self
        
        coverVC.slidingViewController = slidingContainerViewController
        
        var rect: CGRect = slidingContainerViewController.view.frame
        rect.origin.y = 50
        rect.size.height = self.view.frame.size.height - 50
        slidingContainerViewController.view.frame = rect
        self.view.addSubview(slidingContainerViewController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    //MARK: Selector and private methods

    @IBAction func searchAction(sender: UIButton) {
        isSearchEnabled = true
    }
    
    private func searchTextInSections()
    {
        if let vc = slidingContainerViewController.contentViewControllers[slidingContainerViewController.selectedIndex] as? BaseTableVC {
            vc.searchText(searchText);
        }
    }
    
    //MARK: SearchBar Delegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        isSearchEnabled = false
        searchBar.text = nil
        lastSearchText = searchText
        searchText = nil
        searchTextInSections()
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchText = searchBar.text
        searchTextInSections()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        searchText = (searchBar.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: text) as String?
        searchTextInSections()
        
        return true
    }
    
    //MARK: SlidingContainerViewController Delegate
    
    func slidingContainerViewControllerDidMoveToViewController (slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int)
    {
        if let vc: BaseTableVC = slidingContainerViewController.contentViewControllers[slidingContainerViewController.selectedIndex] as? BaseTableVC {
            let isSearch = vc.shouldSearchAvailble()
            searchBtn.hidden = !isSearch
            if isSearch == false {
                isSearchEnabled = false
            }
            
            if isSearchEnabled {
                searchTextInSections()
            }
        }
    }
}

