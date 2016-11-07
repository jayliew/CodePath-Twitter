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
    var id: Int64?
    
    var screenName: String!
    var realName: String?
    var profileImageUrl: URL?
    var retweetedByName: String?
    
    var retweeted: Bool?
    var favorited: Bool?
    
    var user: Dictionary<String, Any>?
    
    init(dictionary: Dictionary <String, Any>){
        
        if let id_key = dictionary["id"]{
            if let id_int = id_key as? NSNumber {
                self.id = id_int.int64Value
                print("--- TWEET ID IS: \(self.id)")
            }
        }else{
            print("---!!! NO TWEET ID? IMPOSSIBLE ")
        }

        print("--- TWEET INIT DICT")
        print(dictionary)
        
        if let rt_status = dictionary["retweeted_status"] as? Dictionary<String, Any>{
            
            print("--- RTSTATUS: ")
            print(rt_status)
            
            if let retweeted = rt_status["retweeted"] as? Bool{
                self.retweeted = retweeted
            }
            
            if let favorited = rt_status["favorited"] as? Bool{
                self.favorited = favorited
            }
            
            if let user = rt_status["user"] as? Dictionary<String, Any> {
                self.user = user
                
                if let statusText = rt_status["text"] as? String {
                    self.text = statusText
                }else{
                    self.text = ""
                }
                retweetCount = (rt_status["retweet_count"] as? Int) ?? 0
                favouritesCount = (rt_status["favorite_count"] as? Int) ?? 0
                
                let timestampString = rt_status["created_at"] as? String
                if let timestampString = timestampString{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                    
                    timestamp = formatter.date(from: timestampString)
                } // timestampString
                
                if let profileImageUrl = user["profile_image_url"] as? String{
                    if let realUrl = URL(string: profileImageUrl) {
                        self.profileImageUrl = realUrl
                    }
                }
                
                var screenNameInRTUser = false
                var realNameInRTUser = false
                if let screenName = user["screen_name"] as? String {
                    self.screenName = screenName
                    screenNameInRTUser = true
                }
                if let realName = user["name"] as? String {
                    self.realName = realName
                    realNameInRTUser = true
                }
                
                if screenNameInRTUser == false || realNameInRTUser == false{
                    // if it's not in the retweeted_status > user dict
                    // look for it in the entities dict
                    
                    if let entities = dictionary["entities"] as? Dictionary<String, Any> {
                        print("--- ENTITIES")
                        if let user_mentions = entities["user_mentions"] as? [Dictionary<String, Any>] {
                            print("--- USER MENTIONS")
                            if let name = user_mentions[0]["name"] as? String{
                                print("--- ENTITIES > USER MENTIONS > REAL NAME: \(name)")
                                self.realName = name
                            }
                            if let screenNameTmp = user_mentions[0]["screen_name"] as? String{
                                self.screenName = screenNameTmp
                            }
                        }else{
                            print("---!!! USER MENTIONS")
                        }
                    }else{
                        print("---!!! ENTITIES")
                    }
                }

            }else
            
            if let retweetedByUser = dictionary["user"] as? Dictionary<String, Any> {
                if let realName = retweetedByUser["name"] as? String {
                    self.retweetedByName = realName
                }
            }
            
        }else{ // if it's NOT a RETWEET
            
            if let retweeted = dictionary["retweeted"] as? Bool{
                self.retweeted = retweeted
            }
            
            if let favorited = dictionary["favorited"] as? Bool{
                self.favorited = favorited
            }

            text = (dictionary["text"] as? String) ?? ""
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favouritesCount = (dictionary["favorite_count"] as? Int) ?? 0
            
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
            
        }// rt_status else
        
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
