//
//  ComposeViewController.swift
//  Moment
//
//  Created by QingTian Chen on 3/10/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit
import AFNetworking

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var inputText: UITextView!
    
    var charCountLabel: UILabel!;
    var tweetButton: UIButton!;
    
    var replyToTweet: Tweet?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputText.delegate = self
        
        
        let navigationBar = self.navigationController!.navigationBar;
        let charCountFrame = CGRect(x: 20, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height);
        charCountLabel = UILabel(frame: charCountFrame);
        charCountLabel.textColor = UIColor(red: 136/255.0, green: 146/255.0, blue: 158/255.0, alpha: 1)
        charCountLabel.text = "140";
        charCountLabel.frame = charCountFrame;
        navigationBar.addSubview(charCountLabel);
        let toolbarView = UIView(frame: CGRectMake(0, 0, 10, 50));
        inputText.inputAccessoryView = toolbarView;
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width;
        tweetButton = UIButton(frame: CGRect(x: screenWidth - 60 - 10, y: 10, width: 60, height: 30));
        tweetButton.backgroundColor = Color.twitterBlue()
        tweetButton.layer.cornerRadius = 5;
        tweetButton.titleLabel?.font = UIFont.systemFontOfSize(14.0);
        tweetButton.setTitle("Tweet", forState: .Normal);
        tweetButton.addTarget(self, action: "onTweetButton", forControlEvents: .TouchDown);
        toolbarView.addSubview(tweetButton);
        if(replyToTweet == nil) {
            print("not a reply");
        } else {
            print("reply");
            inputText.text = "@" + replyToTweet!.tweetUser_screenName!
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }

    func textViewDidBeginEditing(textView: UITextView) {
        if(textView.text == "What's happening?") {
            textView.text = "";
            textView.textColor = UIColor.blackColor();
        }
        //textView.becomeFirstResponder();
    }

    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text == "") {
            textView.text = "What's happening?";
            textView.textColor = Color.twitterGrayLight()
        }
        textView.resignFirstResponder();
    }
    
    func textViewDidChange(textView: UITextView) {
        let charCount = textView.text.characters.count;
        charCountLabel.text = String(140 - charCount);
    }
    
    func onTweetButton() {
        let composedText = inputText.text;
        var sendToId = 0
        if ((replyToTweet?.id_Int) != nil) {
            sendToId = (replyToTweet?.id_Int)!
        }
        TwitterClient.shareInstance.publishTweet(composedText, replyToTweetID: sendToId) { (newTweet: Tweet) -> () in
            
        }
        
        dismissViewControllerAnimated(true, completion: nil);
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
