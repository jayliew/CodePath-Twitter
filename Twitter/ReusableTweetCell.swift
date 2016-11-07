 //
//  ReusableTweetCell.swift
//  Twitter
//
//  Created by Jay Liew on 11/6/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import AFNetworking

class ReusableTweetCell: UITableViewCell {
    
    @IBOutlet weak var topRetweetImageView: UIImageView!
    @IBOutlet weak var topRetweetLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    @IBOutlet weak var heartActionImageView: UIImageView!
    @IBOutlet weak var retweetActionImageView: UIImageView!
    
    var tweet: Tweet! {
        didSet{
            guard tweet != nil else {
                return
            }
            
            tweetTextLabel.text = tweet.text
            
            if let realNameTmp = tweet.realName {
                nameLabel.text = realNameTmp
            }else{
                nameLabel.text = "\(User.currentUser!.name!)"
            }

            if let screenNameTmp = tweet.screenName {
                screenNameLabel.text = "@\(screenNameTmp)"
            }else{
                screenNameLabel.text = "@\(User.currentUser!.screen_name!)"
            }
            
            if let profileImageUrl = tweet.profileImageUrl {
                self.profileImageView.setImageWith(profileImageUrl)
            }
            
            if let retweetedByName = tweet.retweetedByName{
                topRetweetLabel.text = retweetedByName + " Retweeted"
            }else{
                topRetweetLabel.isHidden = true
                topRetweetImageView.isHidden = true
            }
            
            favoritesCountLabel.text = "\(tweet.favouritesCount)"
            retweetCountLabel.text = "\(tweet.retweetCount)"
            
            if let timestamp = tweet.timestamp {
                timestampLabel.text = "• " + timeAgoSinceDate(date: timestamp, numericDates: true)
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
        }
    }
    
    func timeAgoSinceDate(date:Date, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)h"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1h"
            } else {
                return "An hour"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)m"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1m"
            } else {
                return "A minute"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)s"
        } else {
            return "Just now"
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

