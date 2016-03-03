//
//  TwitterClient.swift
//  Moment
//
//  Created by QingTian Chen on 2/27/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let shareInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "2uC2m4mgph54s9gP3gXAoZvWd", consumerSecret: "r2bZydajHG2qOICzVOg5uZRjLSRoH3Urbnp26ThLNB9HLnhe92")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.shareInstance.deauthorize()
        TwitterClient.shareInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterDeomo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(url!)
        }) { (error: NSError!) -> Void in
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            
        }) { (error: NSError!) -> Void in
            self.loginFailure?(error)
        }

    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
    
    func currentAccount(success:(User) ->(), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
    
    func favorite(tweetId: String,success:(AnyObject) ->(), failure: (NSError) -> ()) {
        
        POST("1.1/favorites/create.json?id=\(tweetId)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success(response!)
        }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        }
        
    }
    
    func unfavorite(tweetId: String,success:(AnyObject) ->(), failure: (NSError) -> ()) {
        
        POST("1.1/favorites/destroy.json?id=\(tweetId)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success(response!)
        }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        }
        
    }
    func retweet(tweetId: String,success:(AnyObject) ->(), failure: (NSError) -> ()) {
        
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success(response!)
        }) { (opreation: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        }
    }
    func unretweet(tweetId: String,success:(AnyObject) ->(), failure: (NSError) -> ()) {
        
        POST("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success(response!)
        }) { (opreation: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        }
    }
    
}
