//
//  Tweet.swift
//  Moment
//
//  Created by QingTian Chen on 2/27/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var dictionary: NSDictionary?
    var tweetText: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var tweetUser: NSDictionary?
    var tweetUser_screenName: String?
    var tweetUser_imageUrl: NSURL?
    var id_str: String?
    var isFavorited: Bool?
    var isRetweeted: Bool?
    var isReacted: Bool?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        tweetText = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        tweetUser = dictionary["user"] as? NSDictionary
        
        if let tweetUser = tweetUser {
            tweetUser_screenName = tweetUser["screen_name"] as? String
            
            let tweetUser_imageUrlString = tweetUser["profile_image_url"] as? String
            if let tweetUser_imageUrlString = tweetUser_imageUrlString {
                tweetUser_imageUrl = NSURL(string: tweetUser_imageUrlString)
            }
        }
        
        id_str = dictionary["id_str"] as? String
        let likeStatus = dictionary["favorited"] as? Int
        if likeStatus == 0 {
            isFavorited = false
        } else {
            isFavorited = true
        }
        let retweetStatus = dictionary["retweeted"] as? Int
        if retweetStatus == 0 {
            isRetweeted = false
        } else {
            isRetweeted = true
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    
}

