//
//  TweetCell.swift
//  TwitterCP
//
//  Created by Jake Vo on 2/26/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import AFNetworking
class TweetCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var textTweet: UILabel!
    @IBOutlet weak var rtCount: UILabel!
    @IBOutlet weak var favCount: UILabel!
    @IBOutlet weak var retweetName: UILabel!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    
    
    var tweet: Tweet! {
        
        didSet {
            
            //setting up retweet 
            if tweet.retweetName != nil {
                retweetName.isHidden = false
                retweetIcon.isHidden = false
                retweetName.text = "\(tweet.retweetName!) retweeted"
                retweetIcon.image = UIImage(named: "retweet-icon.png")
            }
            
            if let temp = tweet.profileImage {
                self.avatar.setImageWith(temp)
            }
            
            tweetLabel.text = "@\(tweet.tweetLabel!)"
            self.rtCount.text = String (describing: tweet.retweetCount)
            self.favCount.text = String (describing: tweet.favoritesCount)
            textTweet.text = tweet.text! as String
            //self.avatar.setImageWith(tweet.profileImage!)
            self.name.text = tweet.usertweet as String?
            let timeString = String (describing: tweet.timestamp!)
            let newTypeString = NSString(string: timeString)
            
            time.text = newTypeString.substring(with: NSRange(location: 5, length: 5))
            
            
            
        }
    }
    //avoid data on table view change when scrolling back and forth
    override func prepareForReuse() {
        super.prepareForReuse()
        retweetName.isHidden = true
        retweetIcon.isHidden = true
        //set cell to initial state here, reset or set values, etc.
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        self.rtCount.text = String (describing: tweet.retweetCount + 1)
        //self.favCount.text = String (describing: tweet.favoritesCount)
    }
    
    @IBAction func onFav(_ sender: Any) {
        //self.rtCount.text = String (describing: tweet.retweetCount + 1)
        self.favCount.text = String (describing: tweet.favoritesCount + 1)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatar.layer.cornerRadius = 3
        self.avatar.clipsToBounds = true
        self.name.preferredMaxLayoutWidth = name.frame.size.width
        //self.textTweet.sizeToFit()
        //self.textTweet.adjustsFontSizeToFitWidth = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
