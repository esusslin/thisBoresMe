//
//  headerView.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/21/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class headerView: UICollectionReusableView {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var postsTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!

    
    //clicked follow button
    
    @IBAction func followBtn_clicked(sender: AnyObject) {
        
        print("follow button clicked")
        
        let title = button.titleForState(.Normal)
        
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.currentUser()?.username
            object["followed"] = guestname.last!
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                
                if success {
                    self.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    self.button.backgroundColor = UIColor.greenColor()
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            //unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("followed", equalTo: guestname.last!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                            if success {
                                self.button.setTitle("FOLLOW", forState: UIControlState.Normal)
                                self.button.backgroundColor = UIColor.lightGrayColor()
                            } else {
                                print(error?.localizedDescription)
                            }
                            
                        })
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
        }

        
        
    }
    
        
}
