//
//  Tweet.swift
//  
//
//  Created by Jay Liew on 10/27/16.
//
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favouritesCount: Int = 0
    
    var screenName: String!
    var realName: String?
    var profileImageUrl: URL?
    
    var user: Dictionary<String, Any>?
    
    init(dictionary: Dictionary <String, Any>){
        text = (dictionary["text"] as? String) ?? ""
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timestamp = formatter.date(from: timestampString)
        } // timestampString
        
        
        if let user = dictionary["user"] as? Dictionary<String, Any> {
            self.user = user
            if let profileImageUrl = user["profile_image_url"] as? String{
                if let realUrl = URL(string: profileImageUrl) {
                    self.profileImageUrl = realUrl
                }
            }
            if let screenName = user["screen_name"] as? String {
                self.screenName = screenName
            }
            if let realName = user["name"] as? String {
                self.realName = realName
            }
        } // user
        
    } // init
    
    class func tweetsWithArray(dictionaries: [Dictionary <String, Any>]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
} // Tweet
