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

        // Do any additional setup after loading the view.
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
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
