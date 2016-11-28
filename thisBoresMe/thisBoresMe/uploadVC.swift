//
//  uploadVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/27/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class uploadVC: UIViewController {
    
    //UI objects
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!

    @IBOutlet weak var publishBtn: UIButton!
    


    override func viewDidLoad() {
        super.viewDidLoad()

       alignment()
    }

    
    func alignment() {
        
        let width = self.view.frame.size.width
        
        picImg.frame = CGRectMake(15, self.navigationController!.navigationBar.frame.size.height + 35, width / 4.5, width / 4.5)
        
        titleTxt.frame = CGRectMake(picImg.frame.size.width + 25, picImg.frame.origin.y, width - titleTxt.frame.origin.x - 10, picImg.frame.size.height)
        
        publishBtn.frame = CGRectMake(0, self.tabBarController!.tabBar.frame.origin.y - width / 8, width, width / 8)
    }


}
