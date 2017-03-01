//
//  User.swift
//  TwitterCP
//
//  Created by Jake Vo on 2/25/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: NSString?
    var screenname: NSString?
    var profileURL: NSURL?
    var tagline: NSString?
    var id: Int?
    var dictionaryObj: NSDictionary?
    var screenName: NSString?
    
    init(dictionary: NSDictionary) {
        //print (dictionary)
        
        self.dictionaryObj = dictionary
        
        screenName = dictionary["screen_name"] as? NSString
        id = dictionary["id"] as? Int
        self.name = dictionary["name"] as? NSString
        self.screenname = dictionary["name"] as? NSString
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileURL = NSURL(string: profileUrlString)
        } else {
            profileURL = NSURL(string: "")
        }
        
        self.tagline = dictionary["description"] as? NSString
    }
    
    static var _currentUser: User?
    static let userDidLogout = "UserDidLogout"
    
    class var currentUser: User? {
        get {
            let defaults = UserDefaults.standard
            
            let userData = defaults.object(forKey: "currentUser") as? Data
            
            if let userData = userData {
                
                if let dict = try! JSONSerialization.jsonObject(with: userData, options: []) as? NSDictionary {
                    _currentUser = User(dictionary: dict)
                } else {
                    _currentUser = nil
                }
            }
            
            return _currentUser
        }
        
        set(user) {
            
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = _currentUser {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionaryObj ?? [], options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.removeObject(forKey: "currentUser")
            }
            defaults.synchronize()
        }
    }

    
    
    
}
