//
//  commentVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 12/1/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

var commentuuid = [String]()
var commentowner = [String]()

class commentVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //UI objects
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    var refresher = UIRefreshControl()
    
    //arrays to hold data from server
    
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var commentArray = [String]()
    var dateArray = [NSDate?]()
    
    
    //values for reseting UI to default
    
    var tableViewHeight : CGFloat = 0
    var commentY : CGFloat = 0
    var commentHeight : CGFloat = 0
    
    //variable to hold keyboard frame
    
    var keyboard = CGRect()
    
    // page size
    var page : Int32 = 15
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.redColor()
        
        //title at the top
        self.navigationItem.title = "COMMENTS"
        
        
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: .Plain, target: self, action: #selector(commentVC.back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(commentVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)

        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(commentVC.back(_:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
        //disable button at the onset
        sendBtn.enabled = false

        alignment()
    }
    
    func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        return viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        //hide bottom bar
        self.tabBarController?.tabBar.hidden = true
        
        //call keyboard
        commentTxt.becomeFirstResponder()
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    
    // func loading when keyboard is shown
    func keyboardWillShow(notification : NSNotification) {
        
        // defnine keyboard frame size
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        // move UI up
        UIView.animateWithDuration(0.4) { () -> Void in
            self.tableView.frame.size.height = self.tableViewHeight - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight
            self.commentTxt.frame.origin.y = self.commentY - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight
            self.sendBtn.frame.origin.y = self.commentTxt.frame.origin.y
        }
    }
    
    // func loading when keyboard is hidden
    func keyboardWillHide(notification : NSNotification) {
        
        // move UI down
        UIView.animateWithDuration(0.4) { () -> Void in
            self.tableView.frame.size.height = self.tableViewHeight
            self.commentTxt.frame.origin.y = self.commentY
            self.sendBtn.frame.origin.y = self.commentY
        }
    }

    func alignment() {
        
        // alignnment
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        tableView.frame = CGRectMake(0, 0, width, height / 1.096 - self.navigationController!.navigationBar.frame.size.height - 20)
        tableView.estimatedRowHeight = width / 5.333
        tableView.rowHeight = UITableViewAutomaticDimension
        
        commentTxt.frame = CGRectMake(10, tableView.frame.size.height + height / 56.8, width / 1.306, 33)
        commentTxt.layer.cornerRadius = commentTxt.frame.size.width / 50
        
        sendBtn.frame = CGRectMake(commentTxt.frame.origin.x + commentTxt.frame.size.width + width / 32, commentTxt.frame.origin.y, width - (commentTxt.frame.origin.x + commentTxt.frame.size.width) - (width / 32) * 2, commentTxt.frame.size.height)
        
        //delegates
        commentTxt.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // assign reseting values
        
        tableViewHeight = tableView.frame.size.height
        commentHeight = commentTxt.frame.size.height
        commentY = commentTxt.frame.origin.y
        
    }
    
    //while writing
    
    func textViewDidChange(textView: UITextView) {
        // disable button if entered no text
        
        let spacing = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        if commentTxt.text.stringByTrimmingCharactersInSet(spacing).isEmpty {
            sendBtn.enabled = true
        } else {
            sendBtn.enabled = false
        }
        
        // + paragaph
        if textView.contentSize.height > textView.frame.size.height && textView.frame.height < 130 {
            
            let difference = textView.contentSize.height - textView.frame.size.height
            
            textView.frame.origin.y = textView.frame.origin.y - difference
            textView.frame.size.height = textView.contentSize.height
            
            if textView.contentSize.height + keyboard.height + commentY >= tableView.frame.size.height {
                tableView.frame.size.height = tableView.frame.size.height - difference
            }
        }
        
        else if textView.contentSize.height < textView.frame.size.height {
            
            // find difference to deduct
            let difference = textView.frame.size.height - textView.contentSize.height
            
            textView.frame.origin.y = textView.frame.origin.y + difference
            textView.frame.size.height = textView.contentSize.height
            
            if textView.contentSize.height + keyboard.height + commentY > tableView.frame.size.height {
                tableView.frame.size.height = tableView.frame.size.height + difference
            }
        }
    }
    
    // load comments function
    func loadComments() {
        
        // STEP 1. Count total comments in order to skip all except (page size = 15)
        let countQuery = PFQuery(className: "comments")
        countQuery.whereKey("to", equalTo: commentuuid.last!)
        countQuery.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            
            // if comments on the server for current post are more than (page size 15), implement pull to refresh func
            if self.page < count {
                self.refresher.addTarget(self, action: #selector(commentVC.loadMore), forControlEvents: UIControlEvents.ValueChanged)
                self.tableView.addSubview(self.refresher)
            }
            
            // STEP 2. Request last (page size 15) comments
            let query = PFQuery(className: "comments")
            query.whereKey("to", equalTo: commentuuid.last!)
            query.skip = count - self.page
            query.addAscendingOrder("createdAt")
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, erro:NSError?) -> Void in
                if error == nil {
                    
                    // clean up
                    self.usernameArray.removeAll(keepCapacity: false)
                    self.avaArray.removeAll(keepCapacity: false)
                    self.commentArray.removeAll(keepCapacity: false)
                    self.dateArray.removeAll(keepCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.usernameArray.append(object.objectForKey("username") as! String)
                        self.avaArray.append(object.objectForKey("ava") as! PFFile)
                        self.commentArray.append(object.objectForKey("comment") as! String)
                        self.dateArray.append(object.createdAt)
                        self.tableView.reloadData()
                        
                        // scroll to bottom
                        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.commentArray.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
        })
        
    }
    
    // pagination
    func loadMore() {
        
        // STEP 1. Count total comments in order to skip all except (page size = 15)
        let countQuery = PFQuery(className: "comments")
        countQuery.whereKey("to", equalTo: commentuuid.last!)
        countQuery.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            
            // self refresher
            self.refresher.endRefreshing()
            
            // remove refresher if loaded all comments
            if self.page >= count {
                self.refresher.removeFromSuperview()
            }
            
            // STEP 2. Load more comments
            if self.page < count {
                
                // increase page to load 30 as first paging
                self.page = self.page + 15
                
                // request existing comments from the server
                let query = PFQuery(className: "comments")
                query.whereKey("to", equalTo: commentuuid.last!)
                query.skip = count - self.page
                query.addAscendingOrder("createdAt")
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        self.commentArray.removeAll(keepCapacity: false)
                        self.dateArray.removeAll(keepCapacity: false)
                        
                        // find related objects
                        for object in objects! {
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            self.commentArray.append(object.objectForKey("comment") as! String)
                            self.dateArray.append(object.createdAt)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            }
            
        })
        
    }

    
    
    
    // TABLEVIEW
    // cell numb
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    // cell height
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // cell config
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // declare cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! commentCell
        
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], forState: .Normal)
        cell.usernameBtn.sizeToFit()
        cell.commentLbl.text = commentArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            cell.avaImg.image = UIImage(data: data!)
        }
        
        // calculate date
        let from = dateArray[indexPath.row]
        let now = NSDate()
        let components : NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
        
        if difference.second <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second > 0 && difference.minute == 0 {
            cell.dateLbl.text = "\(difference.second)s."
        }
        if difference.minute > 0 && difference.hour == 0 {
            cell.dateLbl.text = "\(difference.minute)m."
        }
        if difference.hour > 0 && difference.day == 0 {
            cell.dateLbl.text = "\(difference.hour)h."
        }
        if difference.day > 0 && difference.weekOfMonth == 0 {
            cell.dateLbl.text = "\(difference.day)d."
        }
        if difference.weekOfMonth > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth)w."
        }
        
        return cell
    }
    
        // go back
        func back(sender : UIBarButtonItem) {
            
            // push back
            self.navigationController?.popViewControllerAnimated(true)
            
            // clean comment uui from last holding infromation
            if !commentuuid.isEmpty {
                commentuuid.removeLast()
            }
            
            // clean comment owner from last holding infromation
            if !commentowner.isEmpty {
                commentowner.removeLast()
            }
        }
}
