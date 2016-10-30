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
    var client: TwitterClient!
    let refreshControl = UIRefreshControl()
    let blueLogo = UIColor(red:0.00, green:0.67, blue:0.93, alpha:1.0)
    
    override func viewWillAppear(_ animated: Bool) {
        refreshControlAction(refreshControl: refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.backgroundColor = blueLogo
        
        if let client = TwitterClient.sharedInstance {
            self.client = client
        }else{
            print("--- shared instance doesn't exist")
            return
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
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
        ) // homeTimeline

        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

    }
        
    func refreshControlAction(refreshControl: UIRefreshControl){
        print("--- refreshing ... ")
        
        self.client.homeTimeline(
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
        ) // homeTimeline
        
        refreshControl.endRefreshing()
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
