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
    
    var retweeted = false
    var favorited = false
    var retweetName: NSString? = nil
    var user: User?
    var retweetedID: Int?
    var tweetLabel: NSString?
    var user_id: Int?
    

    init(dictionary: NSDictionary) {
        //print(dictionary)
        
        if dictionary["retweeted"] as? Int == 0 {
            retweeted = false
        } else {
            retweeted = true
        }
        
        if dictionary["favorited"] as? Int == 0 {
            favorited = false
        } else {
            favorited = true
        }
        
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        user_id = user!.id!
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool

        tweetLabel = user!.screenName
        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
            if (retweetedStatus["user"] as? NSDictionary) != nil {
                let retweetUser = User(dictionary: retweetedStatus)
                //print(retweetUser)
                retweetName = user!.name! as NSString?
                user = retweetUser
                retweetedID = user?.id
            }
        } else {
            retweetedID = dictionary["id"] as? Int
        }
        //print("id in tweet2 is \(retweetedID)")
        text = dictionary["text"] as? NSString
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let userOnTimeline = dictionary["user"] as! NSDictionary
        profileImage = URL(string: userOnTimeline["profile_image_url"] as! String)
        
        usertweet = userOnTimeline["name"] as? NSString
        
        
        if let timestampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            //Wed Aug 29 17:12:58 +0000 2012
            
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        //print (dictionary["retweeted_status"] ?? "not aval")
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary])  -> [Tweet] {
        var tweets = [Tweet]()
        //var x = 0
        for dictionary in dictionaries {
            
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
            
        }
        
        return tweets
    }
}
