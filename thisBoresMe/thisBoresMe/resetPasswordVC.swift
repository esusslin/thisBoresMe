//
//  resetPasswordVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTxt.frame = CGRectMake(10, 120, self.view.frame.size.width - 20, 30)
        resetBtn.frame = CGRectMake(20, emailTxt.frame.origin.y + 50, self.view.frame.size.width / 4, 30)
        cancelBtn.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width / 4 - 20, resetBtn.frame.origin.y, self.view.frame.size.width / 4, 30)
        
        // background
        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        bg.image = UIImage(named: "boringbackground.jpeg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }


    @IBAction func resetBtnPressed(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if emailTxt.text!.isEmpty {
            
            let alert = UIAlertController(title: "Email", message: "is empty", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // request for resetting password
        PFUser.requestPasswordResetForEmailInBackground(emailTxt.text!) { (success:Bool, error:NSError?) in
            if success {
                let alert = UIAlertController(title: "You've got mail", message: "check your email to reset your password", preferredStyle: UIAlertControllerStyle.Alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    @IBAction func cancelBtnPressed(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
