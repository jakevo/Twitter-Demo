//
//  TweetsViewController.swift
//  TwitterCP
//
//  Created by Jake Vo on 2/26/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking
import MBProgressHUD



class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    @IBOutlet weak var tableview: UITableView!
    var tweetsArray: [Tweet]! = [Tweet]()
    var refresher: UIRefreshControl!
    var tweet: Tweet!
    
    
    //weak var delegate: TweetCellDelegate?
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 250
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(TweetsViewController.refresh), for: UIControlEvents.valueChanged)
        tableview.addSubview(refresher)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.52, blue:0.71, alpha:1.0)
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Twitter_logo_white_32"))
        
        tableview.rowHeight = UITableViewAutomaticDimension
        //refresh()
        //imageReply.tag = (tableview.indexPathForSelectedRow?.row)!
    }
    
    @IBAction func onCompose(_ sender: Any) {
        
        //let defaulst = UserDefaults.standard
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "replyView") as! ReplyViewController
       
        vc.tweet = tweetsArray[0]

        
        self.present(vc, animated: true, completion: nil)

        
    }
    func replyClicked(_ tweet: Tweet?, indexPath: IndexPath) {
        let cell = tableview.cellForRow(at: indexPath) as! TweetCell
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "replyView") as! ReplyViewController
        vc.tweet = cell.tweet
        self.present(vc, animated: true, completion: nil)
    }
    
    func avatarImageClicked(_ tweet: Tweet?, indexPath: IndexPath) {
        
        let params = ["user_id": tweet?.user_id]
        
        TwitterClient.sharedInstance?.getUserID(params: params as NSDictionary?, success: { (user) in
            
            //let cell = self.tableview.cellForRow(at: indexPath) as! TweetCell
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileView") as! ProfileViewController
            vc.user = user
            vc.tweet = tweet
            //vc.tweet = cell.tweet
            let backItem = UIBarButtonItem()
            backItem.title = "Tweet"
            
            self.navigationItem.backBarButtonItem = backItem
            
            let newFont = UIFont(name: "Avenir Next", size: 19.0)!
            let color = UIColor.white
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSForegroundColorAttributeName: color, NSFontAttributeName: newFont], for: .normal)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }, failure: { (error: NSError) in
            print (error.localizedDescription)
        })
    }
    
    
    
    
    func retweetClicked(_ tweet: Tweet?, indexPath: IndexPath) {
        let cell = tableview.cellForRow(at: indexPath) as! TweetCell
        if tweet?.retweeted == false {
            print ("here")

            let reTemp = (tweet?.retweetCount)! + 1
            TwitterClient.sharedInstance?.retweetAction(id: (tweet?.retweetedID!)!, success: { (check: Bool) in
                
                cell.tweet = tweet
                cell.retweetImage.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
                
                cell.rtCount.text = String (describing: reTemp)
                tweet?.retweetCount = reTemp
                //self.rtCount.text = String (describing: reTemp)
                //self.tweet.retweetCount = reTemp
                tweet?.retweeted = check
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        } else {
            print ("there")
            let unReTemp = (tweet?.retweetCount)! - 1
            TwitterClient.sharedInstance?.unRetweetAction(id: (tweet?.retweetedID!)!, success: { (check: Bool) in
                cell.tweet = tweet
                cell.retweetImage.setImage(UIImage(named: "retweet-icon"), for: .normal)
               
                cell.rtCount.text = String (describing: unReTemp)
                tweet?.retweetCount = unReTemp
                tweet?.retweeted = check
                
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }

    }
    
    func favCick(_ tweet: Tweet?, indexPath: IndexPath) {
        let cell = tableview.cellForRow(at: indexPath) as! TweetCell
        if tweet?.favorited == false {
            let reTemp = (tweet?.favoritesCount)! + 1
            TwitterClient.sharedInstance?.favAction(id: (tweet?.retweetedID!)!, success: { (check: Bool) in
                
                cell.tweet = tweet
                cell.favoriteImage.setImage(UIImage(named: "favor-icon-red"), for: .normal)
                
                cell.favCount.text = String (describing: reTemp)
                tweet?.favoritesCount = reTemp
                
                tweet?.favorited = check
                
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        } else {
            let unReTemp = (tweet?.favoritesCount)! - 1
            TwitterClient.sharedInstance?.unFavAction(id: (tweet?.retweetedID!)!, success: { (check: Bool) in

                cell.tweet = tweet
                cell.favoriteImage.setImage(UIImage(named: "favor-icon"), for: .normal)
                cell.favCount.text = String (describing: unReTemp)
                tweet?.favoritesCount = unReTemp
                tweet?.favorited = check
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print ("good")
        getData()
 
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TweetCell
        //dequeueReusableCell(withIdentifier: "cell") as! TweetCell
        
        cell.tweet = self.tweetsArray[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell {
            let indexPath = self.tableview.indexPath(for: cell)
            let tweet = tweetsArray![indexPath!.row]
            let viewController = segue.destination as! TweetDetailViewController
            
            
            let backItem = UIBarButtonItem()
            backItem.title = "Tweet"
            
            navigationItem.backBarButtonItem = backItem
            
            let newFont = UIFont(name: "Avenir Next", size: 19.0)!
            let color = UIColor.white
            
            //change back button color to white
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSForegroundColorAttributeName: color, NSFontAttributeName: newFont], for: .normal)
            viewController.tweet = tweet
        }
    }
    
    func getData() {
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweetsArray.removeAll()
            self.tweetsArray = tweets
            self.tableview.reloadData()
        }) { (error:NSError) in
            print(error.localizedDescription)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
    }

    func refresh() {
        getData()
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
