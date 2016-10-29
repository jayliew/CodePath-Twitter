//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Jay Liew on 10/28/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let client = TwitterClient.sharedInstance else {
            print("--- shared instance doesn't exist")
            return
        }
        
        client.homeTimeline(
            success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                
                for tweet in self.tweets!{
                    print(tweet.text)
                }
            },
            failure: { (error: Error?) -> () in
                print("--- ERROR in getting home timeline" + error!.localizedDescription)
            }
        )
    }
    
    @IBAction func onLogout(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
