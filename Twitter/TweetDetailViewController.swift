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
    @IBOutlet weak var retweetActionImageView: UIImageView!
    @IBOutlet weak var heartActionImageView: UIImageView!
    
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
        
        if let retweeted = tweet.retweeted {
            if(retweeted){
                retweetActionImageView.image = UIImage(named: "retweeted.png")
            }else{
                retweetActionImageView.image = UIImage(named: "retweet.png")
            }
        }

        if let favorited = tweet.favorited {
            if(favorited){
                heartActionImageView.image = UIImage(named: "hearted.png")
            }else{
                heartActionImageView.image = UIImage(named: "heart.png")
            }
        }

    } //viewDidLoad
    
    @IBAction func onFave(_ sender: AnyObject) {
        print("--- TAP FAVE \(tweet.id)")
        let client = TwitterClient.sharedInstance!
        var create: Bool! // true for create, false for destroy
        
        if let favorited = tweet.favorited {
            if(favorited){
                create = false
            }else{
                create = true
            }
        }

        client.favorite(
            id: tweet.id!,
            create: create,
            success: { () -> ()? in
                print("--- CALLBACK FIRED: SUCCESSFULLY \(create) FAVE: \(self.tweet.id!)")
                if let favorited = self.tweet.favorited { // change from previous state
                    if(favorited){
                        self.heartActionImageView.image = UIImage(named: "heart.png")
                        self.tweet.favorited = false
                        self.tweet.favouritesCount = self.tweet.favouritesCount - 1
                        self.favoritesCount.text = "\(self.tweet.favouritesCount)"
                    }else{
                        self.heartActionImageView.image = UIImage(named: "hearted.png")
                        self.tweet.favorited = true
                        self.tweet.favouritesCount = self.tweet.favouritesCount + 1
                        self.favoritesCount.text = "\(self.tweet.favouritesCount)"
                    }
                }
                
                return Void()
            },
            failure: { (error: Error?) -> () in
                print("--- FAILURE CALLBACK FIRED: TWEET \(create) FAVE: \(self.tweet.id!)")
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        )
    } // onFave
    
    @IBAction func onReply(_ sender: AnyObject) {
        print("--- TAP REPLY \(tweet.id)")
        performSegue(withIdentifier: "replySegue", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "replySegue"){
            print("--- PREPARE FOR SEGUE TO REPLY VIEW ")
            let navController = segue.destination as! UINavigationController
            let composeViewController = navController.topViewController as! ComposeViewController
            composeViewController.replyId = tweet.id
            composeViewController.replyScreenName = tweet.screenName
        }
    }

    @IBAction func onRetweet(_ sender: AnyObject) {
        print("--- TAP RETWEET \(tweet.id)")
        var doit: Bool!
        
        if let retweeted = tweet.retweeted {
            if(retweeted){
                doit = false // UN-RT
            }else{
                doit = true // RT
            }
        }
        
        let client = TwitterClient.sharedInstance!
        client.retweet(
            id: tweet.id!,
            doit: doit,
            success: { () -> ()? in
                print("--- CALLBACK FIRED: SUCCESSFULLY \(doit) RETWEET: \(self.tweet.id!)")
                if(doit == true){
                    self.retweetActionImageView.image = UIImage(named: "retweeted.png")
                    self.tweet.retweeted = true
                    self.tweet.retweetCount = self.tweet.retweetCount + 1
                    self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
                }else{
                    self.retweetActionImageView.image = UIImage(named: "retweet.png")
                    self.tweet.retweeted = false
                    self.tweet.retweetCount = self.tweet.retweetCount - 1
                    self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
                }
                return Void()
            },
            failure: { (error: Error?) -> () in
                print("--- FAILURE CALLBACK FIRED: RETWEET \(doit): \(self.tweet.id!)")
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
