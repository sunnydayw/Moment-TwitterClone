//
//  TweetDetailViewController.swift
//  Moment
//
//  Created by QingTian Chen on 3/7/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.rowHeight = UITableViewAutomaticDimension
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - TabelView
extension TweetDetailViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailTableViewCell
        cell.tweets = tweet
        return cell
    }
    
}
