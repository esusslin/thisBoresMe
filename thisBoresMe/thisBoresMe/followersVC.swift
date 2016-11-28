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

            print("lol")
       self.navigationItem.title = show.uppercaseString
        
        if show == "followers" {
            print("goodbye")
            loadFollowers()
        }
        
        if show == "following" {
            print("hello")
            loadFollowing()
        }
    }

    
    
    func loadFollowers() {
        
        // STEP 1: find followers of user
        let followQuery = PFQuery(className: "follow")
        
        followQuery.whereKey("followed", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) in
            if error == nil {
                
                self.followArray.removeAll(keepCapacity: false)
                
                // STEP 2: hold recieved data
                for object in objects! {
                    print(object)
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
                            self.tableView.reloadData()
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
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) in
            if error == nil {
                
                self.followArray.removeAll(keepCapacity: false)
                
                for object in objects! {
                    self.followArray.append(object.valueForKey("followed") as! String)
                }
                
                let query = PFQuery(className: "_User")
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
                    
                    if error == nil {
                        
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        
                        for object in objects! {
                            
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            self.tableView.reloadData()
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
    
    
    
    // cell numb
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
    }
    
    //cell height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
        
        //STEP 1. connect data from serv to objects
        cell.usernameLbl.text = usernameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            if error == nil {
                
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // STEP 2. Show do user following or do not
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("followed", equalTo: cell.usernameLbl.text!)
        query.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) in
            
            if error == nil {
                if count == 0 {
                cell.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
                cell.followBtn.backgroundColor = UIColor.lightGrayColor()
                
            } else {
                cell.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
                cell.followBtn.backgroundColor = UIColor.greenColor()
            }
        }
    }
        //hide follow button for current user
        
        if cell.usernameLbl.text == PFUser.currentUser()?.username {
            cell.followBtn.hidden = true
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //recall cell to call further cell's data
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! followersCell
        
        //user taps on himself, go hom else go guest
        if cell.usernameLbl.text! == PFUser.currentUser()!.username! {
            
            let home  = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
            
        } else {
            
            print("hello?")
            guestname.append(cell.usernameLbl.text!)
            print(cell.usernameLbl.text!)
            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
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
