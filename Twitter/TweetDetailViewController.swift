//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Jay Liew on 10/30/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favoritesCount: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetedByLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realNameLabel.text = tweet.realName!
        screenNameLabel.text = "@\(tweet.screenName!)"
        tweetTextLabel.text = tweet.text
        if let profileImageUrl = tweet.profileImageUrl {
            self.profileImageView.setImageWith(profileImageUrl)
        }

        favoritesCount.text = "\(tweet.favouritesCount)"
        retweetCountLabel.text = "\(tweet.retweetCount)"

        if let timestamp = tweet.timestamp {
            timestampLabel.text = "\(timestamp)"
        }
        
        if let byName = tweet.retweetedByName {
            retweetedByLabel.text = byName + " retweeted"
        }else{
            retweetedByLabel.isHidden = true
            retweetImageView.isHidden = true
        }
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
