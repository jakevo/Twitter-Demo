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

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var tweetsArray: [Tweet]! = [Tweet]()
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 250
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.52, blue:0.71, alpha:1.0)
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Twitter_logo_white_32"))
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweetsArray.removeAll()
            self.tweetsArray = tweets
            self.tableview.reloadData()
        }) { (error:NSError) in
            print(error.localizedDescription)
        }
        tableview.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TweetCell
        //dequeueReusableCell(withIdentifier: "cell") as! TweetCell
        cell.tweet = self.tweetsArray[indexPath.row]
        
        return cell
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
