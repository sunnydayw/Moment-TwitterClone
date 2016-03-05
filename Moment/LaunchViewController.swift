//
//  LaunchViewController.swift
//  Moment
//
//  Created by QingTian Chen on 3/5/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var birdImage: UIImageView!
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = Color.twitterBlue()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.birdImage.transform = CGAffineTransformMakeScale(0.75, 0.75)
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.5, delay: 0.5, options: [], animations: { () -> Void in
                self.birdImage.transform = CGAffineTransformMakeScale(100 , 100)
            }) { (Bool) -> Void in
                if User.currentUser != nil {
                    self.performSegueWithIdentifier("login", sender: self)
                } else {
                    self.performSegueWithIdentifier("showLogin", sender: self)
                }
                
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
