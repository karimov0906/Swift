//
//  MasterListCell.swift
//  vivecatv
//
//  Created by Solar Jang on 9/19/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

class MasterListCell: UITableViewCell {
    
    @IBOutlet var cellTextLabel:UILabel?
    var cellTag:Int = 0


    func initWithCell(tag:Int)
    {
//        if(cellTextLabel == nil)
//        {
//            let cellLabel:UILabel = UILabel(frame: CGRectMake(15, 6, 270, 34))
//            self.cellTextLabel = cellLabel
            self.cellTextLabel!.textColor = UIColor.lightGrayColor()
            self.cellTextLabel!.backgroundColor = UIColor.clearColor()
            self.cellTextLabel!.tag = tag
            
            let selectedImageView:UIImageView = UIImageView(image: UIImage(named: "MasterListSelectedRow"))
            self.selectedBackgroundView = selectedImageView
//            selectedImageView.addSubview(cellLabel)
//            self.contentView.addSubview(cellLabel)
            
//        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMenuItem(titleString:String)
    {
        self.cellTextLabel?.text = titleString
    }

}
