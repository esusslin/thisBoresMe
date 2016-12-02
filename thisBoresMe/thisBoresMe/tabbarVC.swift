//
//  tabbarVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 12/1/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class tabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //color of item
        self.tabBar.tintColor = UIColor.whiteColor()
        
        //color of background
        self.tabBar.barTintColor = UIColor(red: 37.0 / 255.0, green: 39.0 / 255.0, blue: 42.0 / 255.0, alpha: 1)
        
        //disable translucent
        self.tabBar.translucent = false
        
    }



}
