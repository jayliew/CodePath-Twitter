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
        
        TwitterClient.sharedInstance?.homeTimeline(
            success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                
                for tweet in self.tweets!{
                    print(tweet.text)
                }
                
            },
            failure: { (error: Error?) -> () in
            }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
