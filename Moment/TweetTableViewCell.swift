//
//  TweetTableViewCell.swift
//  Moment
//
//  Created by QingTian Chen on 2/28/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweets: Tweet? {
        didSet {
            print(tweets?.tweetUser_screenName)
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
