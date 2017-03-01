//
//  Tweet.swift
//  TwitterCP
//
//  Created by Jake Vo on 2/25/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import AFNetworking


class Tweet: NSObject {

    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileImage: URL?
    var usertweet: NSString?
    
    //var retweeted = false
    //var favorited = false
    var retweetName: NSString? = nil
    var user: User?
    var retweetedID: Int?
    var tweetLabel: NSString?
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
            if (retweetedStatus["user"] as? NSDictionary) != nil {
                //let retweetUser = User(dictionary: retweetStatusUser)
                retweetName = user!.name! as NSString?
                //user = retweetUser
                //retweetedID = user?.id
            }
        }
        tweetLabel = user!.screenName
        text = dictionary["text"] as? NSString
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let userOnTimeline = dictionary["user"] as! NSDictionary
        profileImage = URL(string: userOnTimeline["profile_image_url"] as! String)
        
        usertweet = userOnTimeline["name"] as? NSString
        
        
        if let timestampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y "
            
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        //print (dictionary["retweeted_status"] ?? "not aval")
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary])  -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
