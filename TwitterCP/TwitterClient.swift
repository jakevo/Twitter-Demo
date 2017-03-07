//
//  TwitterClient.swift
//  TwitterCP
//
//  Created by Jake Vo on 2/25/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")! as URL!, consumerKey: "kt5duemHoH7kIKYBfbIEIHnBk", consumerSecret: "VgnuNtcINKpFFKPXU43dCAzGBTf7zwa1xs39AtVrvAgNTEb1Sh")
    
    
    var loginSuccess:  (() -> ())?
    var loginFailure:  ((NSError) -> ())?
    
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/statuses/home_timeline.json?count=100", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            //print (dictionaries[4])
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth")!, scope: nil, success: {
            (requestToken: BDBOAuth1Credential?) -> Void in
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            
        }, failure: {(error: Error?) -> Void in
            self.loginFailure?(error as! NSError)
        })
    }
    
    func logout() {
        //print("loging out......")
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogout), object: nil)
    }
    
    func retweetAction (id: Int, success: @escaping (Bool) -> (), failure: (NSError) -> ()) {
        //print(id)
        
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //let tweet = Tweet(dictionary: response as! NSDictionary)
            //tweet.retweeted = true
            success(true)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func unRetweetAction (id: Int, success: @escaping (Bool) -> (), failure: (NSError) -> ()) {
        //print(id)
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //let tweet = Tweet(dictionary: response as! NSDictionary)
            //tweet.retweeted = false
            success(false)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        })
    }

    func favAction (id: Int, success: @escaping (Bool) -> (), failure: (NSError) -> ()) {
        //print(id)
        
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //let tweet = Tweet(dictionary: response as! NSDictionary)
            //tweet.retweeted = true
            success(true)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func unFavAction(id: Int, success: @escaping (Bool) -> (), failure: (NSError) -> ()) {
        //print(id)
        
        post("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //let tweet = Tweet(dictionary: response as! NSDictionary)
            //tweet.retweeted = true
            success(false)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        })
    }

    func createTweet(params: NSDictionary,success: @escaping (Bool) -> (), failure: (NSError) -> ()) {
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(true)
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func getUserID(params: NSDictionary? ,success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        print (params!)
        get("1.1/users/lookup.json", parameters: params!, progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            let dictionaries = response as! [NSDictionary]

            let user = User(dictionary: dictionaries[0])
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    
    
    
    func handleURL(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error )
            })
            
        }, failure: {(error: Error?) -> Void in
            self.loginFailure?(error as! NSError)
        })
    }
    func currentAccount(success: @escaping (User) -> (), failure: (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let user = User(dictionary: response as! NSDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            self.loginFailure?(error as NSError)
        })
    }
}
