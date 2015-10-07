//
//  TweeterTableViewCell.swift
//  vivecatv
//
//  Created by Solar Jang on 9/21/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

class TweeterTableViewCell: UITableViewCell, UITextViewDelegate {

    var tweetAcountLabel:UILabel?
    var tweetTimeLabel:UILabel?
    var tweetTextView:UITextView?
    var imageData:NSData?
    var profileImage:UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addTweeterImageOnSecondView(9000)
        self.addDetailTextViewOnSecondView(9001)
        self.addTweeterLableOnView(9003)
        self.addTweeterNameLable(9004)
        
        self.imageData = NSData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addTweeterImageOnSecondView(tag:Int)
    {
        self.profileImage = UIImage(data: self.imageData!)
        let tweeterImage:UIImageView = UIImageView(frame: CGRectMake(15,10,40,40))
        tweeterImage.tag = tag
        tweeterImage.image = self.profileImage
        self.addSubview(tweeterImage)
        
    }
    func addDetailTextViewOnSecondView(tag:Int)
    {
        let localTextView = UITextView(frame: CGRectMake(59, 30, 600, 70))
        localTextView.tag = tag
        self.tweetTextView = localTextView
        localTextView.userInteractionEnabled = true
        
        localTextView.scrollEnabled = true
        localTextView.delegate = self
        localTextView.sizeToFit()
        localTextView.setContentOffset(CGPointZero, animated: false)
        localTextView.showsVerticalScrollIndicator = true
        localTextView.backgroundColor = UIColor.clearColor()
        localTextView.font = UIFont(name: "Arial", size: 13)
        localTextView.editable = true
        localTextView.textColor = UIColor.whiteColor()
        self.addSubview(localTextView)
        
    }
    func addTweeterLableOnView(tag:Int)
    {
        self.tweetTimeLabel = UILabel(frame: CGRectMake(495, 5, 200, 30))
        self.tweetTimeLabel?.textColor = UIColor.grayColor()
        self.tweetTimeLabel?.backgroundColor = UIColor.clearColor()
        self.addSubview(self.tweetTimeLabel!)
        
    }
    func addTweeterNameLable(tag:Int)
    {
        self.tweetAcountLabel = UILabel()
        self.tweetAcountLabel?.frame = CGRectMake(65, 5, 150, 30)
        self.tweetAcountLabel?.tag = tag
        self.tweetAcountLabel?.textColor = UIColor.redColor()
        self.tweetAcountLabel?.backgroundColor = UIColor.clearColor()
        self.addSubview(self.tweetAcountLabel!)
    }
    func initWithTweeterAcountName(accountName:String, tweetTest:String, timeLabel:String, image:NSData)
    {
        self.tweetAcountLabel?.text = accountName
        self.tweetTextView?.text = tweetTest
        self.imageData = image
        self.addTweeterImageOnSecondView(9000)
        self.tweetTimeLabel?.text = timeLabel
    }
}
