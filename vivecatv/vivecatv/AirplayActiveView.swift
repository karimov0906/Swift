//
//  AirplayActiveView.swift
//  vivecatv
//
//  Created by Solar Jang on 9/21/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

class AirplayActiveView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var gradientLayer:CAGradientLayer?
    var displayImageView:UIImageView?
    var titleLabel:UILabel?
    var descriptionLabel:UILabel?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer?.colors = [UIColor(white: 0.22, alpha: 1).CGColor, UIColor(white: 0.09, alpha: 1).CGColor]
        self.gradientLayer?.locations = [0, 1]
        self.layer.addSublayer(self.gradientLayer!)
                
        self.displayImageView = UIImageView(image: UIImage(named: "airplay-display.png"))
        self.addSubview(self.displayImageView!)
        
        self.titleLabel = UILabel(frame: CGRectZero)
        self.titleLabel?.text = "Airplay"
        self.titleLabel?.font = UIFont(name: "DINRoundCompPro", size: 20)
        self.titleLabel?.textColor = UIColor(white: 0.5, alpha: 1)
        self.titleLabel?.backgroundColor = UIColor.clearColor()
        
        self.addSubview(self.titleLabel!)
        
        self.descriptionLabel = UILabel(frame: CGRectZero)
        self.descriptionLabel?.text = "This video is playing elsewhere"
        self.descriptionLabel?.font = UIFont(name: "DINRoundCompPro", size: 14)
        self.descriptionLabel?.textColor = UIColor(white: 0.36, alpha: 1)
        self.descriptionLabel?.backgroundColor = UIColor.clearColor()
        
        self.addSubview(self.descriptionLabel!)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        
        let bounds:CGRect = self.bounds
        self.gradientLayer?.frame = bounds
        
        print((self.displayImageView?.image?.size)!)
        
        var displayImageSize:CGSize = (self.displayImageView?.image?.size)!
        
        if(bounds.size.height < 300)
        {
            displayImageSize = CGSizeMake(displayImageSize.width / 2, displayImageSize.height/2)
            
        }
        
        let titleString:NSString = NSString(string: (self.titleLabel?.text)!)
        let descriptionString:NSString = NSString(string: (self.descriptionLabel?.text)!)
        
        let titleLabelSize:CGSize = titleString.sizeWithAttributes([NSFontAttributeName: self.titleLabel!.font])
        let descriptionLabelSize:CGSize = descriptionString.sizeWithAttributes([NSFontAttributeName: self.descriptionLabel!.font])
        
        let contentHeight:CGFloat = displayImageSize.height + titleLabelSize.height + descriptionLabelSize.height
        var y:CGFloat = bounds.size.height / 2 - contentHeight / 2
        
        self.displayImageView?.frame = CGRectMake((bounds.size.width / 2) - (displayImageSize.width / 2), y, displayImageSize.width, displayImageSize.height)
        y += displayImageSize.height
        
        self.titleLabel?.frame = CGRectMake((bounds.size.width / 2) - (titleLabelSize.width / 2),
            y,
            titleLabelSize.width,
            titleLabelSize.height)
        y += titleLabelSize.height
        
        
        self.descriptionLabel?.frame = CGRectMake((bounds.size.width / 2) - (descriptionLabelSize.width / 2),
            y,
            descriptionLabelSize.width,
            descriptionLabelSize.height)
    }
}

























