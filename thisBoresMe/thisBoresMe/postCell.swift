//
//  postCell.swift
//  thisBoresMe
//
//  Created by Emmet Susslin on 11/27/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class postCell: UITableViewCell {
    
    // user stuff
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    //main picture
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var uuidLbl: UILabel!
    
    //buttons
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    //labels
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
