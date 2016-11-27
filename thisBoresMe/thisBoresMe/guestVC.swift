
//
//  guestVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/26/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

var guestname = [String]()

class guestVC: UICollectionViewController {
    
    var refresher : UIRefreshControl!
    var page : Int = 10
    
    var uuidArray = [String]()
    var picArray = [PFFile]()

    override func viewDidLoad() {
        

        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        // allow vertical scroll
        self.collectionView!.alwaysBounceVertical = true
        
        //background color
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        // top title
        self.navigationItem.title = guestname.last
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = backBtn
        
        //swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        //pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        
        // call load posts
        loadPosts()
        
    }
    
    // back function
    func back(sender : UIBarButtonItem) {
        
        //push back
        self.navigationController?.popViewControllerAnimated(true)
        
        //clean guest username or deduct the last guest username from guestname =Array
        
        if !guestname.isEmpty {
            guestname.removeLast()
        }
    }
    
    func refresh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    func loadPosts() {
        
        print("load posts?")
        print(guestname.last!)
        
        //load posts
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: guestname.last!)
        query.limit = page
        
        query.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                //find related objects
                for object in objects! {
                    
                    
                    //hold pulled information in arrays
                    
                    self.uuidArray.append(object.valueForKey("uuid") as! String)
                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    //cell config
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //define cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! pictureCell
        
        // connect data from array to picIMg object from pictureCell class
        
        picArray[indexPath.row].getDataInBackgroundWithBlock ({ (data:NSData?, error:NSError?) in
            
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        })
        
        return cell
    }
    
    //header config
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        //STEP 1. load data of guest
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestname.last!)
        infoQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                if objects!.isEmpty {
                    print("wrong user")
                }
                
                // find related to user
                for object in objects! {
                    header.name.text = (object.objectForKey("fullname") as? String)?.uppercaseString
                    header.bio.text = object.objectForKey("bio") as? String
                    header.bio.sizeToFit()
                    header.website.text = object.objectForKey("web") as? String
                    header.website.sizeToFit()
                    let avaFile : PFFile = (object.objectForKey("ava") as? PFFile)!
                    avaFile.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) in
                        header.avatarImage.image = UIImage(data: data!)
                    })
                }
            } else {
                print(error?.localizedDescription)
            }
        })
        
//        //Step 2. show if current user follows guest
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followQuery.whereKey("followed", equalTo: guestname.last!)
        followQuery.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) in
            
            if error == nil {
                
                if count == 0 {
                    header.button.setTitle("FOLLOW", forState: .Normal)
                    header.button.backgroundColor = UIColor.lightGrayColor()
                } else {
                    header.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    header.button.backgroundColor = UIColor.greenColor()
                }
            } else {
                print(error?.localizedDescription)
            }
        })
        
        //STEP 3. Count statistics
        //count posts
        
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: guestname.last!)
        posts.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) in
            if error == nil {
                
                header.posts.text = "\(count)"
            } else {
                print(error?.localizedDescription)
            }
        })
        
        // count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("followed", equalTo: guestname.last!)
        followers.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) in
            if error == nil {
                header.followers.text = "\(count)"
            }
        }
        
        // count total followed
        let followed = PFQuery(className: "follow")
        followed.whereKey("follower", equalTo: guestname.last!)
        followed.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) in
            if error == nil {
                header.following.text = "\(count)"
            }
        }
        
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
        
        user = guestname.last!
        
        show = "followers"
        
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingsTap() {
        
        user = guestname.last!
        
        show = "following"
        
        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        self.navigationController?.pushViewController(followings, animated: true)
    }
}
