//
//  homeVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/21/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "Cell"

class homeVC: UICollectionViewController {
    
    // refresher variable
    var refresher : UIRefreshControl!
    
    // size of page
    
    var page : Int = 10
    
    var uuidArray = [String]()
    var picArray = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        
        //background color
        collectionView?.backgroundColor = .whiteColor()
        
        // title at the top
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString
        
        //pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        
        loadPosts()

    }
    
    func refresh() {
        
        //reload data information
        collectionView?.reloadData()
        
        refresher.endRefreshing()
    }
    
    func loadPosts() {
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.limit = page
        query.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
            if error == nil {
                
                self.uuidArray.removeAll(keepCapacity: false)
                self.picArray.removeAll(keepCapacity: false)
                
                // find objects related to the request
                for object in objects! {
                    
                    // add found data to arrays (holders)
                    self.uuidArray.append(object.valueForKey("uuid") as! String)
                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                }
                self.collectionView?.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    // cell numb
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picArray.count
    }
    
    //cell size 
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        return size
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! pictureCell
        
        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
    // header config
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        // STEP 1: Get user data
     
        header.name.text = (PFUser.currentUser()?.objectForKey("fullname") as? String)?.uppercaseString
        header.website.text = PFUser.currentUser()?.objectForKey("web") as? String
        header.bio.text = PFUser.currentUser()?.objectForKey("bio") as? String
        header.bio.sizeToFit()
        header.button.setTitle("edit profile", forState: UIControlState.Normal)
        
        let avaQuery = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        avaQuery.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            header.avatarImage.image = UIImage(data: data!)
        }
        
        header.button.setTitle("edit profile", forState: UIControlState.Normal)
        
        
        // STEP 2: Get user stats
        
        //count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        posts.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) in
            if error == nil {
                header.posts.text = "\(count)"
            }
        })
        
        // count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("followed", equalTo: PFUser.currentUser()!.username!)
        followers.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) in
            if error == nil {
                header.followers.text = "\(count)"
            }
        }
        
        // count total followed
        let followed = PFQuery(className: "follow")
        followed.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followed.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) in
            if error == nil {
                header.following.text = "\(count)"
            }
        }
        
        //STEP 3: implement tap gestures
        
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
        postsTap.numberOfTapsRequired = 1
        header.posts.userInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followers.userInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        // tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
        followingsTap.numberOfTapsRequired = 1
        header.following.userInteractionEnabled = true
        header.following.addGestureRecognizer(followingsTap)
        
        
        
        return header
        
    }


    // taped post label
    
    func postsTap() {
        if !picArray.isEmpty {
            
            let index = NSIndexPath(forItem: 0, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
        }
    }
    
    // tapped followers 
    func followersTap() {
        
       user = PFUser.currentUser()!.username!
        
        show = "followers"
        
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingsTap() {
        
        user = PFUser.currentUser()!.username!
        
        show = "following"
        
        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    
    // clicked log out
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) in
            
            if error == nil {
                
                print("log out pressed")
                
                //remove logged in user from App memory
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let signin = self.storyboard?.instantiateViewControllerWithIdentifier("signInVC") as! signInVC
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = signin
            }
        }
        
        
    }
    

}
