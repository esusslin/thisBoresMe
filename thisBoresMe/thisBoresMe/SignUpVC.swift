//
//  SignUpVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var scrollViewHeeigh : CGFloat = 0
    
    var keyboard = CGRect()
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpBtn_click(sender: AnyObject) {
        print("sign up pressed")
    }
    
    @IBAction func cancelBtn_click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    



}
