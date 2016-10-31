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
        
    } //viewDidLoad
    
    @IBAction func onFave(_ sender: AnyObject) {
        print("--- TAP FAVE \(tweet.id)")
        let client = TwitterClient.sharedInstance!
        client.favorite(
            id: tweet.id!,
            success: { () -> ()? in
                print("--- CALLBACK FIRED: SUCCESSFULLY POSTED FAVE: \(self.tweet.id!)")
                self.dismiss(animated: true)
                return Void()
            },
            failure: { (error: Error?) -> () in
                print("--- FAILURE CALLBACK FIRED: RETWEET NOT FAVE: \(self.tweet.id!)")
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        )
    } // onFave
    
    @IBAction func onReply(_ sender: AnyObject) {
        print("--- TAP REPLY \(tweet.id)")
    }
    
    @IBAction func onRetweet(_ sender: AnyObject) {
        print("--- TAP RETWEET \(tweet.id)")
        
        let client = TwitterClient.sharedInstance!
        client.retweet(
            id: tweet.id!,
            success: { () -> ()? in
                print("--- CALLBACK FIRED: SUCCESSFULLY POSTED RETWEET: \(self.tweet.id!)")
                self.dismiss(animated: true)
                return Void()
            },
            failure: { (error: Error?) -> () in
                print("--- FAILURE CALLBACK FIRED: RETWEET NOT POSTED: \(self.tweet.id!)")
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        )
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
