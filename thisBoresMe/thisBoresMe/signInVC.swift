//
//  signInVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {
    
    @IBOutlet weak var boringLabel: UILabel!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!


    @IBOutlet weak var singInBtn: UIButton!
    @IBOutlet weak var forgotpassBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // boring alignment code
        boringLabel.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, 50)
        usernameTxt.frame = CGRectMake(10, boringLabel.frame.origin.y + 70, self.view.frame.size.width - 20, 30)
        passwordTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        forgotpassBtn.frame = CGRectMake(10, passwordTxt.frame.origin.y + 30, self.view.frame.size.width - 20, 30)
        singInBtn.frame = CGRectMake(20, forgotpassBtn.frame.origin.y + 40, self.view.frame.size.width / 4, 30)
        signUpBtn.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width / 4 - 20, singInBtn.frame.origin.y, self.view.frame.size.width / 4, 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        singInBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        
        //tape to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        
        // background
        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        bg.image = UIImage(named: "boringbackground.jpeg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }
    
    func hideKeyboard(recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    

    @IBAction func signInBtn_click(sender: AnyObject) {
        print("sign in pressed")
        
        //hides keyboard
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
           
            // show alert
            let alert = UIAlertController(title: "Please", message: "fill in both fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        //login function
        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:NSError?) in
            if error == nil {
                
                // remember user or save in App Memory
                NSUserDefaults.standardUserDefaults().setObject(user!.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                // call logingfrom AppDelegate.swift
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
    
            } else {
                
                // show alert
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
        
    }


}
