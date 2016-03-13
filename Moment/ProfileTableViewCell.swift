//
//  ProfileTableViewCell.swift
//  Moment
//
//  Created by QingTian Chen on 3/9/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetUser_image: UIImageView!
    @IBOutlet weak var tweetUser_screenName: UILabel!
    @IBOutlet weak var tweetUser_text: UILabel!
    @IBOutlet weak var tweetNameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    var user: User! {
        didSet {
            
            tweetUser_image.setImageWithURL(user.profileImageUrl!)
            
            tweetUser_screenName.text = user.name
            tweetUser_screenName.sizeToFit()
            
            tweetUser_text.text = user.profileDescription
            tweetUser_text.sizeToFit()
            
            tweetNameLabel.text = "@" + (user.screenName)!
            tweetNameLabel.sizeToFit()
            
            followingCountLabel.text = ("1")
            followersCountLabel.text = ("\(user.followersCount!)")
            
            tweetUser_image.layer.cornerRadius = 8
        }
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
