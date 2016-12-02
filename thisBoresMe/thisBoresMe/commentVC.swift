//
//  commentVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 12/1/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

var commentuuid = [String]()
var commentowner = [String]()

class commentVC: UIViewController {
    
    //UI objects
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    var refresh = UIRefreshControl()
    
    //values for reseting UI to default
    
    var tableViewHeight : CGFloat = 0
    var commentY : CGFloat = 0
    var commentHeight : CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alignment()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        //hide bottom bar
        self.tabBarController?.tabBar.hidden = true
        
        //call keyboard
        commentTxt.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }

    func alignment() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.width
        
        tableView.frame = CGRectMake(0, 0, width, height / 1.096 - self.navigationController!.navigationBar.frame.size.height - 20)
        
        commentTxt.frame = CGRectMake(10, commentTxt.frame.size.height + height, width / 1.306, 33)
        
        sendBtn.frame = CGRectMake(commentTxt.frame.origin.x + commentTxt.frame.size.width + width / 32, commentTxt.frame.origin.y, width - (commentTxt.frame.origin.x + commentTxt.frame.size.width - (width / 32) * 2), commentTxt.frame.size.height)
        
        // assign reseting values
        
        tableViewHeight = tableView.frame.size.height
        commentHeight = commentTxt.frame.size.height
        commentY = commentTxt.frame.origin.y
        
        
    }


}
