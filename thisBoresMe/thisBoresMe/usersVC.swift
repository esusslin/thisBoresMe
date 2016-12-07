//
//  usersVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 12/6/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class usersVC: UITableViewController, UISearchBarDelegate {
    
    // declare search bar
    var searchBar = UISearchBar()
    
    // tableView arrays to hold information from server
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    
    
    // collectionView UI
//    var collectionView : UICollectionView!
    
    // collectionView arrays to hold infromation from server
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var page : Int = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // implement search bar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.groupTableViewBackgroundColor()
        searchBar.frame.size.width = self.view.frame.size.width - 34
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        
        // call functions
        loadUsers()
        
        // call collectionView
//        collectionViewLaunch()
    }
    
    // search updated
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // find by username
        let usernameQuery = PFQuery(className: "_User")
        usernameQuery.whereKey("username", matchesRegex: "(?i)" + searchBar.text!)
        usernameQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                // if no objects are found according to entered text in usernaem colomn, find by fullname
                if objects!.isEmpty {
                    
                    let fullnameQuery = PFUser.query()
                    fullnameQuery?.whereKey("fullname", matchesRegex: "(?i)" + self.searchBar.text!)
                    fullnameQuery?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                        if error == nil {
                            
                            // clean up
                            self.usernameArray.removeAll(keepCapacity: false)
                            self.avaArray.removeAll(keepCapacity: false)
                            
                            // found related objects
                            for object in objects! {
                                self.usernameArray.append(object.objectForKey("username") as! String)
                                self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            }
                            
                            // reload
                            self.tableView.reloadData()
                            
                        }
                    })
                }
                
                // clean up
                self.usernameArray.removeAll(keepCapacity: false)
                self.avaArray.removeAll(keepCapacity: false)
                
                // found related objects
                for object in objects! {
                    self.usernameArray.append(object.objectForKey("username") as! String)
                    self.avaArray.append(object.objectForKey("ava") as! PFFile)
                }
                
                // reload
                self.tableView.reloadData()
                
            }
        })
        
        return true
    }
    
    
    // tapped on the searchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        // hide collectionView when started search
//        collectionView.hidden = true
        
        // show cancel button
        searchBar.showsCancelButton = true
    }
    
    
    // clicked cancel button
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // unhide collectionView when tapped cancel button
//        collectionView.hidden = false
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        
        // reset shown users
        loadUsers()
    }

    
    // SEARCHING CODE
    // load users function
    func loadUsers() {
        
        let usersQuery = PFQuery(className: "_User")
        usersQuery.addDescendingOrder("createdAt")
        usersQuery.limit = 20
        usersQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                // clean up
                self.usernameArray.removeAll(keepCapacity: false)
                self.avaArray.removeAll(keepCapacity: false)
                
                // found related objects
                for object in objects! {
                    self.usernameArray.append(object.valueForKey("username") as! String)
                    self.avaArray.append(object.valueForKey("ava") as! PFFile)
                }
                
                // reload
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    // TABLEVIEW CODE
    // cell numb
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    // cell height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }
    
    // cell config
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
        
        // hide follow button
        cell.followBtn.hidden = true
        
        // connect cell's objects with received infromation from server
        cell.usernameLbl.text = usernameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
    
    // selected tableView cell - selected user
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // calling cell again to call cell data
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! followersCell
        
        // if user tapped on his name go home, else go guest
        if cell.usernameLbl.text! == PFUser.currentUser()?.username {
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameLbl.text!)
            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }

    
//    // COLLECTION VIEW CODE
//    func collectionViewLaunch() {
//        
//        // layout of collectionView
//        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        
//        // item size
//        layout.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3)
//        
//        // direction of scrolling
//        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
//        
//        // define frame of collectionView
//        let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
//        
//        // declare collectionView
//        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.alwaysBounceVertical = true
//        collectionView.backgroundColor = .whiteColor()
//        self.view.addSubview(collectionView)
//        
//        // define cell for collectionView
//        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        
//        // call function to load posts
//        loadPosts()
//    }





}
