//
//  ViewController.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {


    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CREATING TABLES AND DATA IN DATABASE
//        let picData = UIImageJPEGRepresentation(picture.image!, 0.5)
//        
//        let file = PFFile(name: "bored.jpeg", data: picData!)
//        
//        let table = PFObject(className: "messages")
//        table["sender"] = "Boner"
//        table["receiver"] = "Bob"
//        table["message"] = "hello bob!"
//        table["picture"] = file
//        table.saveInBackgroundWithBlock { (success:Bool, error:NSError?) in
//            if success {
//                print("saved in server")
//            } else {
//                print(error)
//            }
//        }
        
        // RETRIEVING OBJECTS FROM TABLES IN DATABASE
        
//        let information = PFQuery(className: "messages")
//        information.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) in
//            
//            if error == nil {
//                for object in objects! {
//                    
//                    let message = object["message"] as! String
//                    let receiver = object["receiver"] as! String
//                    let sender = object["sender"] as! String
//                    
//                    self.messageLabel.text = "Message: \(message)"
//                    self.receiverLabel.text = "Receiver: \(receiver)"
//                    self.senderLabel.text = "Sender: \(sender)"
//                    
//                    object["picture"].getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) in
//                        
//                        if error == nil {
//                            if data != nil {
//                                self.picture.image = UIImage(data: data!)
//                            }
//                        }
//                        
//                    })
//                    
//                }
//                } else {
//                    print(error)
//                
//            }
//        }
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

