//
//  TweetDetailViewController.swift
//  TwitterCP
//
//  Created by Jake Vo on 3/4/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    //var profileImage: URL?
    var indexPath:IndexPath?
    var tweet: Tweet!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favCount: UILabel!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var retweetName: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    
    @IBOutlet weak var favImage: UIButton!
    @IBOutlet weak var retweetImage: UIButton!
    
    //weak var delegate: SettingsPresentingViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        retweetLabel.text = "@\(tweet.tweetLabel!)"
        self.profileImage.layer.cornerRadius = 3
        self.profileImage.clipsToBounds = true
        if let temp = tweet.profileImage {
            self.profileImage.setImageWith(temp)
        }
        
        //setting up retweet
        if tweet.retweetName != nil {
            retweetName.isHidden = false
            retweetIcon.isHidden = false
            retweetName.text = "\(tweet.retweetName!) retweeted"
            retweetIcon.image = UIImage(named: "retweet-icon.png")
            
        }

        profileName.text = tweet.usertweet as String?
        text.text = tweet.text! as String
        retweetCount.text = String (describing: tweet.retweetCount)
        favCount.text = String (describing: tweet.favoritesCount)
       
        
        prepareImage()
        
        let timeString = String (describing: tweet.timestamp!)
        let newTypeString = NSString(string: timeString)
        
        
        date.text = newTypeString.substring(with: NSRange(location: 5, length: 5))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func retweetAction(_ sender: Any) {
        //signal = true
        
        if tweet.retweeted == false {
            let reTemp = self.tweet.retweetCount + 1
            TwitterClient.sharedInstance?.retweetAction(id: tweet.retweetedID!, success: { (check: Bool) in
                
                print("there")
                //self.retweetIcon.image = UIImage(named: "retweet-icon-green")
                self.retweetImage.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
                self.retweetCount.text = String (describing: reTemp)
                self.tweet.retweetCount = reTemp
                self.tweet.retweeted = check
                
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        } else {
            let unReTemp = self.tweet.retweetCount - 1
            TwitterClient.sharedInstance?.unRetweetAction(id: tweet.retweetedID!, success: { (check: Bool) in
                self.tweet.retweetCount = unReTemp
                print("here")
                self.retweetImage.setImage(UIImage(named: "retweet-icon"), for: .normal)
                self.retweetCount.text = String (describing: unReTemp)
                self.tweet.retweeted = check
                
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "replyView") as! ReplyViewController
        
        vc.tweet = tweet
        
        self.present(vc, animated: true, completion: nil)
       
    }
    
    @IBAction func favAction(_ sender: Any) {
        
        if tweet.favorited == false {
            let reTemp = self.tweet.favoritesCount + 1
            TwitterClient.sharedInstance?.favAction(id: tweet.retweetedID!, success: { (check: Bool) in
                
                
                self.favImage.setImage(UIImage(named: "favor-icon-red"), for: .normal)
                self.favCount.text = String (describing: reTemp)
                self.tweet.favoritesCount = reTemp
                self.tweet.favorited = check
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        } else {
            let unReTemp = self.tweet.favoritesCount - 1
            TwitterClient.sharedInstance?.unFavAction(id: tweet.retweetedID!, success: { (check: Bool) in
                
                self.tweet.favoritesCount = unReTemp
                self.favImage.setImage(UIImage(named: "favor-icon"), for: .normal)
                self.favCount.text = String (describing: unReTemp)
                self.tweet.favorited = check
                
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }

    }
    
    func prepareImage() {
        
        if tweet.retweeted == true {
            self.retweetImage.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            self.retweetImage.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        if tweet.favorited == true {
            self.favImage.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            self.favImage.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
