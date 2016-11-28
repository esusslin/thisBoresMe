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

    override func awakeFromNib() {
        
        //alignment
        let width = UIScreen.mainScreen().bounds.width
        
        avatarImage.frame = CGRectMake(width / 16, width / 16, width / 4, width / 4)
        
        posts.frame = CGRectMake(width / 2.5, avatarImage.frame.origin.y, 50, 30)
        followers.frame = CGRectMake(width / 1.7, avatarImage.frame.origin.y, 50, 30)
        following.frame = CGRectMake(width / 1.25, avatarImage.frame.origin.y, 50, 30)
        
        postsTitle.center = CGPointMake(posts.center.x, posts.center.y + 20)
        followersTitle.center = CGPointMake(followers.center.x, followers.center.y + 20)
        followingTitle.center = CGPointMake(following.center.x, following.center.y + 20)
        
        button.frame = CGRectMake(postsTitle.frame.origin.x, postsTitle.center.y + 20, width - postsTitle.frame.origin.x - 10, 30)
        
        name.frame = CGRectMake(avatarImage.frame.origin.x, avatarImage.frame.origin.y + avatarImage.frame.size.height, width - 30, 30)
        
        website.frame = CGRectMake(avatarImage.frame.origin.x - 5, name.frame.origin.y + 15, width - 30, 30)
        bio.frame = CGRectMake(avatarImage.frame.origin.x, website.frame.origin.y + 30, width - 30, 30)
        
        // round avatar
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
    }
    
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
