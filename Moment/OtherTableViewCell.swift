
//
//  OtherTableViewCell.swift
//  Moment
//
//  Created by QingTian Chen on 3/10/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit

class OtherTableViewCell: UITableViewCell {
    // MARK: - Outlet Initialization
    @IBOutlet weak var tweetUser_image: UIImageView!
    @IBOutlet weak var tweetUser_screenName: UILabel!
    @IBOutlet weak var tweetUser_text: UILabel!
    @IBOutlet weak var tweetUser_timestamp: UILabel!
    @IBOutlet weak var favorCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var tweetNameLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var rectionButton: UIButton!
    @IBOutlet weak var switchCellButton: UIButton!
    
    var likeTap : Bool?
    var retweetTap : Bool?
    var reactionTap : Bool?
    var current_id: String = ""
    let client = TwitterClient.shareInstance
    var url: NSURL?
    // MARK: - tweets Initialization
    var tweets: Tweet! {
        didSet {
            
            // get tweet id
            current_id = tweets.id_str!
            tweetUser_image.setImageWithURL(tweets.tweetUser_imageUrl!)
            tweetUser_screenName.text = tweets.tweetUser_name
            tweetUser_screenName.sizeToFit()
            tweetUser_text.text = tweets.tweetText as? String
            tweetUser_text.sizeToFit()
            
            tweetNameLabel.text = "@" + (tweets.tweetUser_screenName)!
            tweetNameLabel.sizeToFit()
            tweetNameLabel.tintColor = Color.twitterGrayLight()
            
            favorCountLabel.text = ("\(tweets.favoritesCount)")
            retweetCountLabel.text = ("\(tweets.retweetCount)")
            
            tweetUser_image.layer.cornerRadius = 8
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm:ss";
            let time = formatter.stringFromDate(tweets.timestamp!);
            tweetUser_timestamp.text = ("\(time)")
            tweetUser_timestamp.sizeToFit()
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        likeButton.addTarget(self, action: "likeStatusChanged", forControlEvents: UIControlEvents.TouchUpInside)
        retweetButton.addTarget(self, action: "retweetStatusChanged", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension OtherTableViewCell {
    // MARK: - Like Button
    func likeStatusChanged() {
        if likeTap == true {
            likeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
            likeTap = false
            client.unfavorite(current_id, success: { (response: AnyObject) -> () in
                print("unfavorite OK")
                self.tweets.favoritesCount -= 1
                self.favorCountLabel.text = ("\(self.tweets.favoritesCount)")
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
        } else {
            likeButton.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Normal)
            likeTap = true
            client.favorite(current_id, success: { (response: AnyObject) -> () in
                print("favorite OK")
                self.tweets.favoritesCount += 1
                self.favorCountLabel.text = ("\(self.tweets.favoritesCount)")
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
        }
    }
    
    // MARK: - Retweet Button
    func retweetStatusChanged(){
        if retweetTap == true {
            retweetButton.setImage(UIImage(named: "retweet-action"), forState: UIControlState.Normal)
            retweetTap = false
            client.unretweet(current_id, success: { (response: AnyObject) -> () in
                print("unretweet OK")
                self.tweets.retweetCount -= 1
                self.retweetCountLabel.text = ("\(self.tweets.retweetCount)")
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Normal)
            retweetTap = true
            client.retweet(current_id, success: { (response: AnyObject) -> () in
                print("retweet OK")
                self.tweets.retweetCount += 1
                self.retweetCountLabel.text = ("\(self.tweets.retweetCount)")
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            
        }
    }
}


