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
    var offset = 20
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //tweets = []
        loadMoreData()
        addStyle()
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        scrollViewSetup()
        
}

    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.shareInstance.logout()
    }
    
    func switchCell(switchCell: TweetCell) {
        let indexPath =  tableView.indexPathForCell(switchCell)
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle());
        let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileViewNavigationController") as! UINavigationController;
        let profile = vc.viewControllers.first as! ProfileViewController;
        profile.tweet = tweets![(indexPath?.row)!]
        self.presentViewController(vc, animated: true, completion: nil);
        
    }
    func DetailtweetCellReaction(tweetCell: TweetCell) {
        let indexPath =  tableView.indexPathForCell(tweetCell)
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc = storyboard.instantiateViewControllerWithIdentifier("composeNavigationController") as! UINavigationController
        let composeVC = vc.viewControllers.first as! ComposeViewController;
            composeVC.replyToTweet = tweets![(indexPath?.row)!]
        self.presentViewController(vc, animated: true, completion: nil);

    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "pushToDetail" ) {
            //Dispatch.async(delay: 0) {self.timer.invalidate()}
            let cell = sender as! UITableViewCell
            let index = tableView.indexPathForCell(cell)
            let tweet = tweets![(index?.row)!]
            let detailviewcontroller = segue.destinationViewController as! TweetDetailViewController
            detailviewcontroller.tweet = tweet
        }
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
    
    func loadMoreData() {
        TwitterClient.shareInstance.homeTimelineWithOffset(offset, success:{ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            for (index,tweet) in tweets.enumerate() {
                self.likeStates[index] = tweet.isFavorited
                self.retweetStates[index] = tweet.isRetweeted
            }
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
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
        tableView.estimatedRowHeight = 150
    }
}

// MARK: - Refresh Control
extension TweetsViewController {
    func refreshControlAction(refreshControl: UIRefreshControl) {
        offset = 20
        tweets = []
        loadMoreData()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}
// MARK: - Infinite Scroll
extension TweetsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                self.loadingMoreView?.frame = frame
                self.loadingMoreView!.startAnimating()
                TwitterClient.shareInstance.homeTimelineWithOffset(offset, success:{ (tweets: [Tweet]) -> () in
                    self.offset += 20
                    self.tweets = tweets
                    for (index,tweet) in tweets.enumerate() {
                        self.likeStates[index] = tweet.isFavorited
                        self.retweetStates[index] = tweet.isRetweeted
                    }
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                    }) { (error: NSError) -> () in
                        self.loadingMoreView?.stopAnimating()
                        print(error.localizedDescription)
                }
            }
        }
    }
    func scrollViewSetup() {
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
}