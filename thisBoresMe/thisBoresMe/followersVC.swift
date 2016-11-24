//
//  followersVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/21/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

var show = String()
var user = String()

class followersVC: UITableViewController {
    
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    
    var followArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

       self.navigationItem.title = show.uppercaseString
        
        if show == "followers" {
            loadFollowers()
        }
        
        if show == "following" {
            loadFollowing()
        }
    }

    
    
    func loadFollowers() {
        
        // STEP 1: find followers of user
        let followQuery = PFQuery(className: "follow")
        
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) in
            if error == nil {
                
                self.followArray.removeAll(keepCapacity: false)
                
                // STEP 2: hold recieved data
                for object in objects! {
                    self.followArray.append(object.valueForKey("follower") as! String)
                    
                }
                
                // findUser class data of users who follow THE userfa
                
                
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
                    
                    if error == nil {
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        
                        // find related objects in User class of Parse
                        
                        for object in objects! {
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            }
                        } else {
                            print(error!.localizedDescription)
                        }
                })
            } else {
                print(error!.localizedDescription)
            }
        }
    
    }

    func loadFollowing() {
        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) in
            if error == nil {
                
                self.followArray.removeAll(keepCapacity: false)
                
                for object in objects! {
                    self.followArray.append(object.valueForKey("followings") as! String)
                }
                
                let query = PFQuery(className: "User")
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
                    
                    if error == nil {
                        
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        
                        for object in objects! {
                            
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
