//
//  commentCell.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 12/1/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class commentCell: UITableViewCell {
    
    //UI objects
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var commentLbl: KILabel!
    @IBOutlet weak var dateLbl: UILabel!


    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //alignment
        
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        commentLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        // set constraints
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[username]-(-2)-[comment]-5-|", options: [], metrics: nil, views: ["username":usernameBtn, "comment":commentLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[date]", options: [], metrics: nil, views: ["date":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[ava(40)]", options: [], metrics: nil, views: ["ava":avaImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[ava(40)]-13-[comment]-20-|", options: [], metrics: nil, views: ["ava":avaImg, "comment":commentLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[ava]-13-[username]", options: [], metrics: nil, views: ["ava":avaImg, "username":usernameBtn    ]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[date]-10-|", options: [], metrics: nil, views: ["date":dateLbl]))
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        
    }


}
