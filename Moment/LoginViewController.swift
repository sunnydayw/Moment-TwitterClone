//
//  LoginViewController.swift
//  Moment
//
//  Created by QingTian Chen on 2/27/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    @IBOutlet weak var buttonView: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonView.backgroundColor = Color.twitterBlue()
        buttonView.layer.cornerRadius = 3
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        TwitterClient.shareInstance.login({ () -> () in
            
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
    
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
