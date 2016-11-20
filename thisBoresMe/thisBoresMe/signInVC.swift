//
//  signInVC.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class signInVC: UIViewController {
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!


    @IBOutlet weak var singInBtn: UIButton!
    @IBOutlet weak var forgotpassBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signInBtn_click(sender: AnyObject) {
        print("sign in pressed")
    }


}
