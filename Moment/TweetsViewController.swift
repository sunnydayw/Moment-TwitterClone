//
//  TweetsViewController.swift
//  Moment
//
//  Created by QingTian Chen on 2/27/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, TweetCellDelegate {
    
    var tweets: [Tweet]?
    var likeStates = [Int:Bool]()
    var retweetStates = [Int:Bool]()
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //tweets = []
        TwitterClient.shareInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            for (index,tweet) in tweets.enumerate() {
                self.likeStates[index] = tweet.isFavorited
                self.retweetStates[index] = tweet.isRetweeted
            }
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
        addStyle()
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
}

    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.shareInstance.logout()
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}

// MARK: - TabelView
extension TweetsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        if let tweets = tweets {
            cell.tweets = tweets[indexPath.row]
            cell.delegate = self
            if likeStates[indexPath.row] != nil {
                if likeStates[indexPath.row] == false {
                    cell.likeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                    cell.likeTap = false
                } else {
                    cell.likeButton.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Normal)
                    cell.likeTap = true
                }
            }
            if retweetStates[indexPath.row] != nil {
                if retweetStates[indexPath.row] == false {
                    cell.retweetButton.setImage(UIImage(named: "retweet-action"), forState: UIControlState.Normal)
                    cell.retweetTap = false
                } else {
                    cell.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Normal)
                    cell.retweetTap = true
                }
            }
        }
        return cell
    }
    
    func tweetCellLike(tweetCell: TweetCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(tweetCell)!
        likeStates[indexPath.row] = value
    }
    
    func tweetCellRetweet(tweetCell: TweetCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(tweetCell)!
        retweetStates[indexPath.row] = value
    }
    func tweetCellReaction(tweetCell: TweetCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(tweetCell)!
        retweetStates[indexPath.row] = value
    }
    
}

// MARK: - Style
extension TweetsViewController {
    func addStyle() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        let logo = UIImage(named: "Twitter_logo_blue_32")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        //tableview
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
}

// MARK: - Refresh Control
extension TweetsViewController {
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.shareInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            for (index,tweet) in tweets.enumerate() {
                self.likeStates[index] = tweet.isFavorited
                self.retweetStates[index] = tweet.isRetweeted
            }
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}
