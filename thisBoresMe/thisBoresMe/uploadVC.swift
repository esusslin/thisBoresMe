//
//  uploadVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/27/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //UI objects
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!

    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishBtn.enabled = false
        publishBtn.backgroundColor = UIColor.lightGrayColor()
        
        //hide remove button
        removeBtn.hidden = true
        
        //standard UI containt
        picImg.image = UIImage(named: "grey.jpeg")
       
        
        // hide keyboard tap
        
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //select image tap
        let picTap = UITapGestureRecognizer(target: self, action: "selectImg")
        picTap.numberOfTapsRequired = 1
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(picTap)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        alignment()
    }
    
    //hide keyboard function
    
    func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    
    func selectImg() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }

        // hold selected image in picImg and dismiss pickercontroller
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // enable publish btn
        publishBtn.enabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        // unhide remove button
        
        removeBtn.hidden = false
        
        // implement second tap for zooming image
        
        let zoomTap = UITapGestureRecognizer(target: self, action: "zoomImg")
        zoomTap.numberOfTapsRequired = 1
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
        
    }
    
    
    //zooming IN / Out Function
    func zoomImg() {
        
        //define frame of zoomed image
        let zoomed = CGRectMake(0, self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, self.view.frame.size.width, self.view.frame.size.width)
        
        //frame of unzoomed (small) image
        let unzoomed = CGRectMake(15, 15, self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        
        if picImg.frame == unzoomed {
            
            //with animation
            UIView.animateWithDuration(0.3, animations: { 
                
                //resize image frame
                self.picImg.frame = zoomed
                
                //hide objects from background
                self.view.backgroundColor = UIColor.blackColor()
                self.titleTxt.alpha = 0
                self.publishBtn.alpha = 0
                self.removeBtn.alpha = 0
                
            })
            
            //to unzoom
        } else {
            
            //with animation
            UIView.animateWithDuration(0.3, animations: {
                
                //resize image frame
                self.picImg.frame = unzoomed
                
                //unhide objects from background
                
                self.view.backgroundColor = UIColor.whiteColor()
                self.titleTxt.alpha = 1
                self.publishBtn.alpha = 1
                self.removeBtn.alpha = 1
                
            })
        }
        
    }
    
    
    
    
    
    
    
    func alignment() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        picImg.frame = CGRectMake(15, 15, width / 4.5, width / 4.5)
        titleTxt.frame = CGRectMake(picImg.frame.size.width + 25, picImg.frame.origin.y, width / 1.488, picImg.frame.size.height)
        publishBtn.frame = CGRectMake(0, height / 1.09, width, width / 8)
        removeBtn.frame = CGRectMake(picImg.frame.origin.x, picImg.frame.origin.y + picImg.frame.size.height, picImg.frame.size.width, 20)
    }
    
    
    @IBAction func publishBtn_pressed(sender: AnyObject) {
        
        //dismiss keyboard
        
        self.view.endEditing(true)
        
        //sent data to server to 'posts' class in Parse
        let object = PFObject(className: "posts")
        object["username"] = PFUser.currentUser()!.username
        object["ava"] = PFUser.currentUser()!.valueForKey("ava") as! PFFile
        object["uuid"] = "\(PFUser.currentUser()!.username) \(NSUUID().UUIDString)"
        
        if titleTxt.text.isEmpty {
            object["title"] = ""
            
        } else {
            object["title"] = titleTxt.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        // send pic to server after converting to FILE and compression
        let imageData = UIImageJPEGRepresentation(picImg.image!, 0.5)
        let imageFile = PFFile(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        
        //save post to server and return to homepage
        object.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) in
            
            if error == nil {
                
                //inform user post has been uploaded
                NSNotificationCenter.defaultCenter().postNotificationName("uploaded", object: nil)
                
                //go home
                self.tabBarController!.selectedIndex = 0
                
                // reset the page
                self.viewDidLoad()
                self.titleTxt.text = ""
            }
        })
     
    }
    
    @IBAction func removeBtn(sender: AnyObject) {
        self.viewDidLoad()
        
    }
    
    
    
    


}
