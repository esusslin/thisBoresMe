//
//  SignUpVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avatarImage: UIImageView!

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var retypePasswordTxt: UITextField!
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollViewHeight : CGFloat = 0
    
    var keyboard = CGRect()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // scrollview frame size
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
        
        // round avatar
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
        //declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap:")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // delcare select image tap capacity
        let avaTap = UITapGestureRecognizer(target: self, action: "loadImg:")
        avaTap.numberOfTapsRequired = 1
        avatarImage.userInteractionEnabled = true
        avatarImage.addGestureRecognizer(avaTap)
        
        // incredibly boring alignment code
        avatarImage.frame = CGRectMake(self.view.frame.size.width / 2 - 40, 40, 80, 80)
        usernameTxt.frame = CGRectMake(10, avatarImage.frame.origin.y + 90, self.view.frame.size.width - 20, 30)
        passwordTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        retypePasswordTxt.frame = CGRectMake(10, passwordTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        emailTxt.frame = CGRectMake(10, retypePasswordTxt.frame.origin.y + 60, self.view.frame.size.width - 20, 30)
        fullnameTxt.frame = CGRectMake(10, emailTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        bioTxt.frame = CGRectMake(10, fullnameTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        webTxt.frame = CGRectMake(10, bioTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        signUpBtn.frame = CGRectMake(20, webTxt.frame.origin.y + 50, self.view.frame.size.width / 4, 30)
        cancelBtn.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width / 4 - 20, signUpBtn.frame.origin.y, self.view.frame.size.width / 4, 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        cancelBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
    
        
        // background
        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        bg.image = UIImage(named: "boringbackground.jpeg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
    }
    
    func loadImg(recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avatarImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // hide keyboard if tapped
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // show keyboard
    func showKeyboard(notification:NSNotification) {
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        UIView.animateWithDuration(0.4) { 
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    // hide keyboard
    func hideKeyboard(notification:NSNotification) {
        UIView.animateWithDuration(0.4) { 
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        print("sign up pressed")
        
        self.view.endEditing(true)
        
        //if fields are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || retypePasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty) {
            
            let alert = UIAlertController(title: "Please", message: "fill out all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        //if passwords don't match
        if passwordTxt.text != retypePasswordTxt.text {
            let alert = UIAlertController(title: "PASSWORDS", message: "Do not match", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //send data to server to related columns
        
        let user = PFUser()
        user.username = usernameTxt.text?.lowercaseString
        user.email = emailTxt.text?.lowercaseString
        user.password = passwordTxt.text
        user["fullname"] = fullnameTxt.text?.lowercaseString
        user["bio"] = bioTxt.text
        user["web"] = webTxt.text?.lowercaseString
        
        // in edit profile
        user["tel"] = ""
        user["gender"] = ""
        
        let avatarData = UIImageJPEGRepresentation(avatarImage.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avatarData!)
        
        user["ava"] = avaFile
        
        
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) in
            if success {
                print("registered")
                
                // remember logged user
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                // call login func from AppDelegate class & open app
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
                
            } else {
                // show alert
                let alert = UIAlertController(title: "Please", message: "fill in both fields", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    



}
