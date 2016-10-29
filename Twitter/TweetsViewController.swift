//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Jay Liew on 10/28/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
                self.tableView.reloadData()
            },
            failure: { (error: Error?) -> () in
                print("--- ERROR in getting home timeline" + error!.localizedDescription)
            }
        )
    }
    
    // MARK: UITableView Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = nil
        cell.tweet = tweets?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }else{
            return 0
        }
    }
    
    @IBAction func onLogout(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
