//
//  User.swift
//  Moment
//
//  Created by QingTian Chen on 2/27/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    var profile_banner_url: NSURL?
    var profileBackgroundImageUrl: NSURL?
    var tagline: String?
    var dictionary: NSDictionary?
    var followersCount: Int?
    var profileDescription: String?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        
        screenName = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileImageUrl = NSURL(string: profileUrlString)
        }
        
        let profileBackgroundImageUrlString = dictionary["profile_background_image_url_https"] as? String
        if let profileBackgroundImageUrlString = profileBackgroundImageUrlString {
            profileBackgroundImageUrl = NSURL(string: profileBackgroundImageUrlString)
        }
        
        let profile_banner_urlString = dictionary["profile_banner_url"] as? String
        if let profile_banner_urlString = profile_banner_urlString{
            profile_banner_url = NSURL(string: profile_banner_urlString)
        }
        
        tagline = dictionary["name"] as? String
        
        followersCount = dictionary["followers_count"] as? Int
        
        profileDescription = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
                
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
