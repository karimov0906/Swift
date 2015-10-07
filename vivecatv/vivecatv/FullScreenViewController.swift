//
//  FullScreenViewController.swift
//  vivecatv
//
//  Created by Solar Jang on 9/21/15.
//  Copyright © 2015 mmibroadcasting. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {
    
    var allowPortraitFullscreen:Bool?
    var fullScreenView:FullScreenView?

    override func loadView() {
        
        super.loadView()
        
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.fullScreenView = FullScreenView(frame: self.view.frame)
        
        self.view = self.fullScreenView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        if(self.allowPortraitFullscreen == false)
        {
            return UIInterfaceOrientationMask.Landscape
        }
        else
        {
            return UIInterfaceOrientationMask.All
        }
    }
    
//    override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool {
//        
//        
//        if(self.allowPortraitFullscreen == false)
//        {
//            return UIInterfaceOrientationIsLandscape(toInterfaceOrientation)
//        }
//        else
//        {
//            return true
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
