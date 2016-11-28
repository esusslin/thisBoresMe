//
//  postVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/27/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

var postuuid = [String]()

class postVC: UITableViewController {
    
    
    //arrays to hold information from server
    
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var dateArray = [NSDate?]()
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var titleArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //title label at the top
        self.navigationItem.title = "PHOTO"
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        // dynamic cell hieght
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 450
        
        // find posts
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                //clean up 
                self.avaArray.removeAll(keepCapacity: false)
                self.usernameArray.removeAll(keepCapacity: false)
                self.dateArray.removeAll(keepCapacity: false)
                self.picArray.removeAll(keepCapacity: false)
                self.uuidArray.removeAll(keepCapacity: false)
                self.titleArray.removeAll(keepCapacity: false)
                
                //find related objects
                
                for object in objects! {
                    
                    self.avaArray.append(object.valueForKey("ava") as! PFFile)
                    self.usernameArray.append(object.valueForKey("username") as! String)
                    self.dateArray.append(object.createdAt)
                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                    self.uuidArray.append(object.valueForKey("uuid") as! String)
                    self.titleArray.append(object.valueForKey("title") as! String)
                    
                }
            }
        })
        
    }


    
    //cell numb
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    //cell config
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //define cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! postCell
        
        //connect objects with our information from arrays
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], forState: UIControlState.Normal)
        cell.uuidLbl.text = uuidArray[indexPath.row]
        
        //place avatar
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            cell.avatarImage.image = UIImage(data: data!)
        }
        
        //place post picture
        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            cell.picImg.image = UIImage(data: data!)
        }
        
        return cell
    }
    
    
    
}
