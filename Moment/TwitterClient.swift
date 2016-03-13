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
    
    
    static let shareInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "Mb2xUc9QtXL8cfWOuQsge1Bng", consumerSecret: "sutBgp9orvFLTP8BZvVIDlTyVD123aqaoLcI0TeQUbKm6iJEK5")
    
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
   
    func getfriendlist(screen_name: String, success:(Int) ->(), failure: (NSError)->()) {
        GET(" https://api.twitter.com/1.1/friends/ids.json?screen_name=\(screen_name)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! NSDictionary
            let count = dictionaries["ids"]?.count ?? 0
            success(count)
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func userTimeline(screen_name: String, success:([Tweet]) ->(), failure: (NSError)->()) {
        GET("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(screen_name)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
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
    
    func homeTimelineWithOffset(count: Int, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        var parameter: [String: AnyObject] = ["count": count]
        parameter["count"] = count
        GET("1.1/statuses/home_timeline.json", parameters: parameter, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
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
    
    func publishTweet(text: String, replyToTweetID: Int? = 0, success: (Tweet) -> ()) {
        if(text == "") {
            return;
        }
        let params = ["status": text, "in_reply_to_status_id": Int((replyToTweetID)!)];
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary);
            success(tweet);
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
        }
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
