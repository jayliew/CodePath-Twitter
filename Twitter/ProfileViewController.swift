//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Jay Liew on 11/5/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var statusesCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 220
        
        tableView.register(UINib(nibName: "ReusableTweetCell", bundle: nil), forCellReuseIdentifier: "ReusableTweetCell")
        
        let user = User.currentUser!
        
        nameLabel.text = user.name
        screenNameLabel.text = "@\(user.screen_name!)"
        
        print("--- LOADED PROFILE VIEW CONTROLLER")
        
        if user.profileUrl != nil {
            profileImageView.setImageWith(user.profileUrl!)
        }else{
            if user.profileUrlInsecure != nil {
                profileImageView.setImageWith(user.profileUrlInsecure!)
            }
        }
        
        if user.bannerUrl != nil {
            backgroundImageView.setImageWith(user.bannerUrl!)
        }
        
        if user.tagline != nil {
            descriptionLabel.text = user.tagline!
        }
        
        if user.followersCount != nil {
            followersCount.text = "\(user.followersCount!)"
        }

        if user.following != nil {
            followingCount.text = "\(user.following!)"
        }

        if user.statusesCount != nil {
            statusesCount.text = "\(user.statusesCount!)"
        }
        
        TwitterClient.sharedInstance?.userTimeline(
            screen_name: user.screen_name!,
            success: { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
            },
            failure: { (error: Error?) in
                print("---!!! USER TIMELINE FAILURE")
            })
        
    } // viewDidLoad
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableTweetCell", for: indexPath) as! ReusableTweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        }else{
            return 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
