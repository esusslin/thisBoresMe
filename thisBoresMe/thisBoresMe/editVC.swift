//
//  editVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/27/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class editVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var bio: UITextView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    //picker view
    
    var genderPicker : UIPickerView!
    let genders = ["male", "female"]
    
    var keyboard = CGRect()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a picker
        
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackgroundColor()
        genderPicker.showsSelectionIndicator = true
        gender.inputView = genderPicker
        
        //check keyboard notifications - shown?
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        let avaTap = UITapGestureRecognizer(target: self, action: "loadImg:")
        avaTap.numberOfTapsRequired = 1
        avatarImage.userInteractionEnabled = true
        avatarImage.addGestureRecognizer(avaTap)

        alignment()
        
        //call information function
        information()
        
    }
    
    func alignment() {
        
        let width = self.view.frame.size.width
        let hieght = self.view.frame.size.height
        
        scrollView.frame = CGRectMake(0, 0, width, hieght)
        
        avatarImage.frame = CGRectMake(width - 68 - 10, 15, 68, 68)
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
        name.frame = CGRectMake(10, avatarImage.frame.origin.y, width - avatarImage.frame.size.width - 30, 30)
        username.frame = CGRectMake(10, name.frame.origin.y + 40, width - avatarImage.frame.size.width - 30, 30)
        website.frame = CGRectMake(10, username.frame.origin.y + 40, width - 20, 30)
        
        bio.frame = CGRectMake(10, website.frame.origin.y + 40, width - 20, 60)
        bio.layer.borderWidth = 1
        bio.layer.borderColor = UIColor(red: 230 / 255.5, green: 230 / 255.5, blue: 230 / 255.5, alpha: 1).CGColor
        bio.layer.cornerRadius = bio.frame.size.width / 50
        bio.clipsToBounds = true
        
        
        email.frame = CGRectMake(10, bio.frame.origin.y + 100, width - 20, 30)
        tel.frame = CGRectMake(10, email.frame.origin.y + 40, width - 20, 30)
        gender.frame = CGRectMake(10, tel.frame.origin.y + 40, width - 20, 30)
        
        titlelabel.frame = CGRectMake(15, email.frame.origin.y - 30, width - 20, 30)
        
        
        
    }
    
    // KEYBOARD
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        UIView.animateWithDuration(0.4) { 
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.4) { 
            self.scrollView.contentSize.height = 0
        }
    }
    
    func information() {
        
        let ava = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        ava.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            self.avatarImage.image = UIImage(data: data!)
        }
        
        username.text = PFUser.currentUser()?.username
        name.text = PFUser.currentUser()?.objectForKey("bio") as? String
        bio.text = PFUser.currentUser()?.objectForKey("bio") as? String
        website.text = PFUser.currentUser()?.objectForKey("web") as? String
        
        email.text = PFUser.currentUser()?.email
        tel.text = PFUser.currentUser()?.objectForKey("tel") as? String
        gender.text = PFUser.currentUser()?.objectForKey("gender") as? String
    }
    
    // regex on email
    
    func validateEmail (email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.rangeOfString(regex, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    // validate website
    
    func validateWeb (web : String) -> Bool {
        let regex = "www.+[A-Z0-9a-z._%+-]+.[A-Za-z]{2}"
        let range = web.rangeOfString(regex, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    func alert (error: String, message : String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //NAV bar buttons

    @IBAction func save_pressed(sender: AnyObject) {
        
        if !validateWeb(website.text!) {
            alert("Incorrect website", message: "please provide correct website")
            return
        }
        
        if !validateEmail(email.text!) {
            alert("Incorrect email", message: "please provide correct email")
            return
        }
        
        let user = PFUser.currentUser()!
        user.username = username.text?.lowercaseString
        user.email = email.text?.lowercaseString
        user["name"] = name.text?.lowercaseString
        user["web"] = website.text?.lowercaseString
        user["bio"] = bio.text?.lowercaseString
        
        if tel.text!.isEmpty {
            user["tel"] = ""
        } else {
            user["tel"] = tel.text
        }
        
        if gender.text!.isEmpty {
            user["gender"] = ""
        } else {
            user["gender"] = gender.text
        }
    
        let avaData = UIImageJPEGRepresentation(avatarImage.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        // send executed information to the server
        
        user.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) in
            if success {
                
                self.view.endEditing(true)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                //send notification to homeVC to be reloaded.
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    @IBAction func cancel_pressed(sender: AnyObject) {
        
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // func to call UIImagePickerController
    func loadImg (recognizer : UITapGestureRecognizer)  {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
  
    }
    
    //method to finalize actions w UIImagePickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avatarImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // picker view methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // picker text numb
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    // picker text config
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    //picker did selected some value from it
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender.text = genders[row]
        self.view.endEditing(true)
    }

}
