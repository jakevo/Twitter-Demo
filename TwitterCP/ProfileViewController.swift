//
//  ProfileViewController.swift
//  TwitterCP
//
//  Created by Jake Vo on 3/6/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    var tweet: Tweet!
    
    @IBOutlet var coverPhoto: UIImageView!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var followingCount: UILabel!
    @IBOutlet var followerCount: UILabel!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var username: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableview.rowHeight = UITableViewAutomaticDimension
        //tableview.estimatedRowHeight = 120
        let image = UIImage(named: "Twitter_logo_white_32")
        self.navigationItem.titleView = UIImageView(image: image)
        getData()
        // Do any additional setup after loading the view.
        
    }

    func getData() {
        username.text = "\(user!.name!)"
        tweetLabel.text = "@\(user!.screenName!)"
        //tweetCountLabel.text = "\(user!.tweetCount!)"
        //followingCount.text = "\(user!.following!)"
        //followerCount.text = "\(user!.followers!)"
        
        if let followingCount = user.following {
            self.followingCount.text = String(describing: followingCount)
        }
        
        if let followerCount = user.followers  {
            self.followerCount.text = String(describing: followerCount)
        }

        avatar.setImageWith(tweet.profileImage!)
        
        if let coverImage = user!.coverImage {
            coverPhoto.setImageWith(coverImage)
        }
        
        
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
