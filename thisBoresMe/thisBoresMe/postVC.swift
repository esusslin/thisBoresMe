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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "liked", object: nil)
        
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
                
                self.tableView.reloadData()
            }
        })
        
    }
    
    //auto refresh function
    func refresh() {
        
        self.tableView.reloadData()
    }


    
    //cell numb
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usernameArray.count
    }
    
    //cell config
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //define cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! postCell
        
        //connect objects with our information from arrays
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], forState: UIControlState.Normal)
        cell.uuidLbl.text = uuidArray[indexPath.row]
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        
        //place avatar
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            cell.avatarImage.image = UIImage(data: data!)
        }
        
        //place post picture
        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            cell.picImg.image = UIImage(data: data!)
        }
        
        let from = dateArray[indexPath.row]
        let now = NSDate()
        let components : NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
        
        //logic what to show in seconds, minutes, hours, days, or weeks
        
        if difference.second <= 0 {
            cell.dateLbl.text = "now"
        }
        
        if difference.second > 0 && difference.minute == 0 {
            cell.dateLbl.text = "\(difference.second)s."
        }
        
        if difference.minute > 0 && difference.hour == 0 {
            cell.dateLbl.text = "\(difference.minute)s."
        }
        
        if difference.hour > 0 && difference.day == 0 {
            cell.dateLbl.text = "\(difference.hour)h"
        }
        
        if difference.day > 0 && difference.weekOfMonth == 0 {
            cell.dateLbl.text = "\(difference.day)d."
        }
        
        if difference.weekOfMonth > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth)w."
        }
        
        //color like button accordingly
        
        let didLike = PFQuery(className: "likes")
        didLike.whereKey("by", equalTo: PFUser.currentUser()!.username!)
        didLike.whereKey("to", equalTo: cell.uuidLbl!.text!)
        didLike.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) in
            if count == 0 {
                cell.likeBtn.setTitle("unlike", forState: .Normal)
                cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
            } else {
                cell.likeBtn.setTitle("like", forState: .Normal)
                cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
            }
        }
        
        // count total likes
        let countLikes = PFQuery(className: "likes")
        countLikes.whereKey("to", equalTo: cell.uuidLbl.text!)
        countLikes.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) in
            cell.likeLbl.text = "\(count)"
        }
        
        
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
        print(cell.dateLbl.text)
        return cell
    }
    
    
    // username button pressed
    @IBAction func usernameBtn_click(sender: AnyObject) {
        
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        //call cell to call further cell data
        
        let cell = tableView.cellForRowAtIndexPath(i) as! postCell
        
        if cell.usernameBtn.titleLabel?.text == PFUser.currentUser()?.username {
            
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            
            guestname.append(cell.usernameBtn.titleLabel!.text!)
            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
        
    }
    
    
    
    // go back function
    func back(sender: UIBarButtonItem) {
        
        // push back
        self.navigationController?.popViewControllerAnimated(true)
        
        //clean post uuid from last hold
        if !postuuid.isEmpty {
            postuuid.removeLast()
        }
    }
    
    
    
}
