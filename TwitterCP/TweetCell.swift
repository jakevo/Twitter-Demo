//
//  TweetCell.swift
//  TwitterCP
//
//  Created by Jake Vo on 2/26/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetCellDelegate {
    
    //@objc optional func proFileImageClicked(_ tweet: Tweet?)
     @objc optional func replyClicked(_ tweet: Tweet?, indexPath: IndexPath)
     @objc optional func retweetClicked(_ tweet: Tweet?, indexPath: IndexPath)
     @objc optional func avatarImageClicked(_ tweet: Tweet?, indexPath: IndexPath)
     @objc optional func favCick(_ tweet: Tweet?, indexPath: IndexPath)
}


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
    @IBOutlet weak var retweetImage: UIButton!
    @IBOutlet weak var favoriteImage: UIButton!
    //@IBOutlet weak var replyButton: UIButton!
    weak var delegate: TweetCellDelegate?
    var indexPath: IndexPath?
    
    
    var status: Bool = false
    var check: Bool?
    var checkForFav: Bool?
    //var tweetTemp: Tweet!
    let date = Date()
    var resultDateType1: String?
    var resultDateType2: String?
    var resultHour: String?
    var resultMin: String?
    
    
    var tweet: Tweet! {
        
        didSet {
            //adjust symbol retweet base retweeted status
            if tweet.retweeted == true {
                self.retweetImage.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            } else {
                self.retweetImage.setImage(UIImage(named: "retweet-icon"), for: .normal)
            }
            if tweet.favorited == true {
                self.favoriteImage.setImage(UIImage(named: "favor-icon-red"), for: .normal)
            } else {
                self.favoriteImage.setImage(UIImage(named: "favor-icon"), for: .normal)
            }
            
            
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
            
            
            if let someLabel = tweet.tweetLabel {
                tweetLabel.text = "@\(someLabel)"
            }
            
            self.rtCount.text = String (describing: tweet.retweetCount)
            self.favCount.text = String (describing: tweet.favoritesCount)
            
            textTweet.text = tweet.text! as String
    
            self.name.text = tweet.usertweet as String?
            
            //Wed Aug 29 17:12:58 +0000 2012
            let timeString = String (describing: tweet.timestamp!)
            let newTypeString = NSString(string: timeString)
            let dateAndHour = newTypeString.components(separatedBy: " ")
            let tweetDate = dateAndHour[0]
        

            //tweet post same day
            if tweetDate == resultDateType1 {
                
                let result = prepareTime(temp: dateAndHour[1])
    
                if  result.right == 0 {
                    time.text = "\(result.left)m"
                } else {
                    time.text = "\(result.left)h"
                }
                
            } else {
                time.text = resultDateType2!
            }
        }
    }
    
    func addTapGesture(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TweetCell.clickedProfileImage(_:)))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func clickedProfileImage(_ sender: UITapGestureRecognizer){
        
            delegate?.avatarImageClicked!(self.tweet, indexPath: self.indexPath!)
        
    }
    
    func prepareTime(temp: String) -> (left: Int, right: Int) {
        
        var ret = temp.components(separatedBy: ":")
        
        
        if ((Int(resultHour!)! - (Int(ret[0])! - 8)) == 0) {
            print ("here")
            return ((Int(resultMin!)!) - (Int(ret[1])!), 0)
        }
        
        return ((Int(resultHour!)! - (Int(ret[0])! - 8)), 1)
    }
    
    
    //avoid data on table view change when scrolling back and forth
    override func prepareForReuse() {
        super.prepareForReuse()
        retweetName.isHidden = true
        retweetIcon.isHidden = true
        //set cell to initial state here, reset or set values, etc.
    }
    
    @IBAction func onReply(_ sender: Any) {
        
        delegate?.replyClicked!(self.tweet, indexPath: self.indexPath!)
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        delegate?.retweetClicked!(self.tweet, indexPath: self.indexPath!)
    }
    
    @IBAction func onFav(_ sender: Any) {
        delegate?.favCick!(self.tweet, indexPath: self.indexPath!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatar.layer.cornerRadius = 3
        self.avatar.clipsToBounds = true
        self.name.preferredMaxLayoutWidth = name.frame.size.width
        repareDateAndHour()
        addTapGesture()
    }
    
    func repareDateAndHour() {
        
        let formatterDateType1 = DateFormatter()
        formatterDateType1.dateFormat = "yyyy-MM-dd"
        
        let formatterDateType2 = DateFormatter()
        formatterDateType2.dateFormat = "MMM dd"
        
        let formatterHour = DateFormatter()
        formatterHour.dateFormat = "HH"
        
        let formatterMin = DateFormatter()
        formatterMin.dateFormat = "mm"
        
        resultDateType1 = formatterDateType1.string(from: date)
        resultDateType2 = formatterDateType2.string(from: date)
        //print("xxxx \(resultDateType1!)")
        resultHour = formatterHour.string(from: date)
        resultMin = formatterMin.string(from: date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
