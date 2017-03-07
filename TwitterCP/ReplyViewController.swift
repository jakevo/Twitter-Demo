//
//  ReplyViewController.swift
//  TwitterCP
//
//  Created by Jake Vo on 3/5/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit


class ReplyViewController: UIViewController, UITextViewDelegate {

    var tweet: Tweet!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameReplyTo: UILabel!
    @IBOutlet weak var wordMaxCount: UILabel!
    @IBOutlet weak var textReply: UITextView!
    @IBOutlet weak var retweetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textReply.becomeFirstResponder()
        
        if tweet != nil {
            profileImage.setImageWith(tweet.profileImage!)
            nameReplyTo.text = tweet.usertweet as? String
            retweetLabel.text = "@\(tweet.tweetLabel!)"
            textReply.text.append("@\(tweet.tweetLabel!) ")
        } else {
            print("XxxX")
        }
        
        //wordMaxCount.text = "125"
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTweet(_ sender: Any) {
        
        if textReply.text.isEmpty {
            //popup alert
        } else {
            let params: NSMutableDictionary = (dictionary: ["status": textReply.text])
            params.setValue("@\(tweet.tweetLabel!)", forKey: "in_reply_to_screen_name")
            
            TwitterClient.sharedInstance?.createTweet(params: params ,success: { (check: Bool) in
                
             self.performSegue(withIdentifier: "backHome", sender: self)
             print(params)
                
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelReply(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
