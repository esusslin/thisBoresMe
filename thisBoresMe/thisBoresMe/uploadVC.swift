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
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishBtn.enabled = false
        publishBtn.backgroundColor = UIColor.lightGrayColor()
        
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
        
        // implement second tap for zooming image
        
        let zoomTap = UITapGestureRecognizer(target: self, action: "zoomImg")
        zoomTap.numberOfTapsRequired = 1
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
        
    }
    
    
    //zooming IN / Out Function
    func zoomImg() {
        
        let zoomed = CGRectMake(0, self.view.center.y - self.view.center.x, self.view.frame.size.width, self.view.frame.size.width)
        
        let unzoomed = CGRectMake(15, self.navigationController!.navigationBar.frame.size.height + 35, self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        
        if picImg.frame == unzoomed {
            
            //with animation
            UIView.animateWithDuration(0.3, animations: { 
                
                //resize image frame
                self.picImg.frame = zoomed
                
                //hide objects from background
                self.view.backgroundColor = UIColor.blackColor()
                self.titleTxt.alpha = 0
                self.publishBtn.alpha = 0
                
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
            })
        }
        
    }
    
    
    
    
    
    
    
    func alignment() {
        
        let width = self.view.frame.size.width
        
        picImg.frame = CGRectMake(15, self.navigationController!.navigationBar.frame.size.height + 35, width / 4.5, width / 4.5)
        
        titleTxt.frame = CGRectMake(picImg.frame.size.width + 25, picImg.frame.origin.y, width - titleTxt.frame.origin.x - 10, picImg.frame.size.height)
        
        publishBtn.frame = CGRectMake(0, self.tabBarController!.tabBar.frame.origin.y - width / 8, width, width / 8)
    }


}
