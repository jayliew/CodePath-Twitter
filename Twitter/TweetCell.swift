//
//  TweetCell.swift
//  Twitter
//
//  Created by Jay Liew on 10/28/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var topRetweetImageView: UIImageView!
    @IBOutlet weak var topRetweetLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            guard tweet != nil else {
                return
            }
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.realName
            screenNameLabel.text = tweet.screenName
            
            if let profileImageUrl = tweet.profileImageUrl {
                self.profileImageView.setImageWith(profileImageUrl)
            }
            
            if let retweetedByName = tweet.retweetedByName{
                topRetweetLabel.text = retweetedByName + " retweeted"
            }else{
                topRetweetLabel.isHidden = true
                topRetweetImageView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
