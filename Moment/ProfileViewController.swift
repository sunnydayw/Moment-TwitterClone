//
//  ProfileViewController.swift
//  Moment
//
//  Created by QingTian Chen on 3/9/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var tweet: Tweet?
    var mytweet: [Tweet]?
    var user: User?
    @IBOutlet weak var backgroundImg: UIImageView!
    
    private let kTableHeaderHeigth: CGFloat = 300.0
    private let kTableHeaderCutAway: CGFloat = 40.0
    var headerMaskLayer: CAShapeLayer!
    var headerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let _user = tweet!.tweetUser
        user = User(dictionary: _user!)
        if let id = user?.screenName!{
            TwitterClient.shareInstance.userTimeline(id, success: { (tweet: [Tweet]) -> () in
                self.mytweet = tweet
                self.tableView.reloadData()
                print("mytweet count \(self.mytweet?.count)")
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
            }
        }
        backgroundImg.setImageWithURL((user?.profile_banner_url)!)
        
        let navigationBar = navigationController?.navigationBar
        // Sets background to a blank/empty image
        navigationBar!.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        navigationBar!.shadowImage = UIImage()
        // Sets the translucent background color
        navigationBar!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        navigationBar!.translucent = true
        
        navigationBar!.tintColor = UIColor.whiteColor()
        navigationBar!.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.title = user?.name!
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false
        
        //tableView.addSubview(headerView)
        //print("i got tweet \(tweet!.dictionary)")
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeigth, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeigth)
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer
        updateHeaderView()
        
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backToTweetPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - TabelView
extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if var count = mytweet?.count {
            count = (mytweet!.count + 1)
            print("count is\(count)")
            return count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as! ProfileTableViewCell
            cell.user = user
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("otherCell", forIndexPath: indexPath) as! OtherTableViewCell
            cell.tweets = mytweet![indexPath.row]
            return cell
        }
        
        
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
// MARK: - HeaderView

extension ProfileViewController {
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeigth, width: tableView.bounds.width, height: kTableHeaderHeigth)
        if tableView.contentOffset.y < -kTableHeaderHeigth {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height-kTableHeaderCutAway))
        headerMaskLayer?.path = path.CGPath
    }
    
}

// MARK: - ScrollView
extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
}

