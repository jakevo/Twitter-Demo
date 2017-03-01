//
//  LoginViewController.swift
//  TwitterCP
//
//  Created by Jake Vo on 2/24/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager



class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
    
        let client = TwitterClient.sharedInstance!
        client.login(success: { 
            
            self.performSegue(withIdentifier: "showTweet", sender: nil)
            
        }) { (error: NSError) in
            print(error.localizedDescription)
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
