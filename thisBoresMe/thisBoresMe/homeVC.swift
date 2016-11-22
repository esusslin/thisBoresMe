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
        
        collectionView?.backgroundColor = .whiteColor()
        
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString
        
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
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! pictureCell
        
        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        // get users data with connections to columns of PFUser class
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
        
        return header
        
    }

//    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
//    
//        // Configure the cell
//    
//        return cell
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
