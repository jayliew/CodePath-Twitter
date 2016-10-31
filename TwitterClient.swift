//
//  TwitterClient.swift
//  Twitter
//
//  Created by Jay Liew on 10/27/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "5hlxVelD8OH6rX9JSbCrA96bH"
let twitterConsumerSecret = "HO7y19uiVojefq2BKpF3fBrZs1GRk1WpPZ0X2CHsU7blvedXTt"

let twitterConsumerKey2 = "P8iRLxzPKBnrWKGwvrjXpK2aw"
let twitterConsumerSecret2 = "N3TPdHag1Fm9Qgh7dxsP7GeJb54l3csTYKLOXA5kv4YvqW5560"

let twitterBaseURL = URL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1SessionManager {
    
    // Singleton
    
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey2, consumerSecret: twitterConsumerSecret2)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error?) -> ())?
    
    func favorite(id: Int64, success: @escaping () -> ()?, failure: @escaping (Error?) -> ()?){
        guard let client = TwitterClient.sharedInstance else {
            return
        }
        let endpoint = "1.1/favorites/create.json"
        
        var params = Dictionary<String, Any>()
        params["id"] = id
        
        client.post(endpoint,
                    parameters: params,
                    progress: { (progress: Progress) in
                        print("--- progress in favoriting")
            },
                    success: { (dataTask: URLSessionDataTask, response: Any?) in
                        print("--- SUCCESS in favoriting")
                        success()
            },
                    failure: { (dataTask: URLSessionDataTask?, error: Error) in
                        print("--- FAIL in favoriting")
                        failure(error)
            }
        ) // client.post
    } // retweet
    
    func retweet(id: Int64, success: @escaping () -> ()?, failure: @escaping (Error?) -> ()?){
        guard let client = TwitterClient.sharedInstance else {
            return
        }
        let endpoint = "1.1/statuses/retweet/\(id).json"
        
        var params = Dictionary<String, Any>()
        params["id"] = id
        
        client.post(endpoint,
                    parameters: params,
                    progress: { (progress: Progress) in
                        print("--- progress in retweeting")
            },
                    success: { (dataTask: URLSessionDataTask, response: Any?) in
                        print("--- SUCCESS in posting REtweet")
                        success()
            },
                    failure: { (dataTask: URLSessionDataTask?, error: Error) in
                        print("--- FAIL in posting REtweet")
                        failure(error)
            }
        ) // client.post
    } // retweet
    
    func postTweet(tweet: String, id: Int64?, success: @escaping () -> ()?, failure: @escaping (Error?) -> ()?){
        guard let client = TwitterClient.sharedInstance else {
            return
        }
  
        if(tweet.characters.count > 140 || tweet.characters.count == 0){
            failure(nil)
            return
        }
        
        var params = Dictionary<String, Any>()
        params["status"] = tweet
        
        if let id = id {
            params["in_reply_to_status_id"] = id
        }
        
        client.post("1.1/statuses/update.json",
                    parameters: params,
                    progress: { (progress: Progress) in
                        print("--- progress in posting  tweet")
                    },
                    success: { (dataTask: URLSessionDataTask, response: Any?) in
                        print("--- SUCCESS in posting tweet")
                        success()
                    },
                    failure: { (dataTask: URLSessionDataTask?, error: Error) in
                        print("--- FAIL in posting tweet")
                        failure(error)
                    }
        ) // client.post
        
    }//postTweet
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error?) -> ()){
        guard let client = TwitterClient.sharedInstance else {
            return
        }
        
        client.get(
            "1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: { (progress: Progress) in
                print("--- progress downloading home timeline")
            },
            success: { (dataTask: URLSessionDataTask, response: Any?) in
                print("--- SUCCESS GET home timeline")
                if let responseArray = response as? [Dictionary <String, Any>]{
                    let tweets = Tweet.tweetsWithArray(dictionaries: responseArray)
                    success(tweets)
                }
            }, // success
            failure: { (dataTask: URLSessionDataTask?, error: Error) in
                print("--- GET FAILURE home timeline")
                failure(error)
            } // failure
        ) // get data
        
    } // homeTimeline
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error?) -> ()){
        guard let client = TwitterClient.sharedInstance else {
            return
        }
        
        client.get(
            "1.1/account/verify_credentials.json",
            parameters: nil,
            progress: { (progress: Progress) in
                print("--- progress downloading USER")
            },
            success: { (dataTask: URLSessionDataTask, response: Any?) in
                print("--- SUCCESS GET USER")
                if let dict = response as? NSDictionary{
                    let user = User(initDictionary: dict)
                    success(user)
                }
            }, // success
            failure: { (dataTask: URLSessionDataTask?, error: Error) in
                print("--- GET FAILURE USER")
                failure(error)
            } // failure
        ) // get data
        
    } // currentAccount
    
    func handleOpenUrl(url: URL){
        guard let client = TwitterClient.sharedInstance else {
            return
        }
        
        client.fetchAccessToken(withPath: "oauth/access_token",
                                method: "POST",
                                requestToken: BDBOAuth1Credential(queryString: url.query),
                                success: { (accessToken: BDBOAuth1Credential?) in
                                    print("--- ACCESS token success")
                                    client.requestSerializer.saveAccessToken(accessToken)
                                    
                                    client.currentAccount(
                                        success: { (user: User) in
                                            print("--- SUCCESS currentAccount()")
                                            // print(user)
                                            User.currentUser = user
                                            self.loginSuccess?()
                                        },
                                        failure: { (error: Error?) in
                                            self.loginFailure?(error)
                                        }
                                    )
                                    
                                    //self.loginSuccess?()
            }, // success fetch access
            failure: { (error: Error?) in
                if error != nil {
                    self.loginFailure?(error!)
                }else{
                    print("--- ACCESS token fail")
                }
            } // fail
        ) // fetchAccessToken
        
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }

    func login(success:@escaping () -> (), failure:@escaping (Error?) -> ()){
        let client = TwitterClient.sharedInstance
        loginSuccess = success // callback
        loginFailure = failure // callback
        
        client?.requestSerializer.clearAuthorizationHeader()
        
        client?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) in
                print("--- GOT access token")
                if let token = requestToken {
                    if let request = token.token {
                        let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request)")
                        // send user to Twitter's web site for auth
                        UIApplication.shared.open(authURL!)
                        
                    }else{
                        print("--- failed to get access token")
                        //     self.loginFailure?()
                    }
                }else{
                    print("--- failed to get access token")
                    //   self.loginFailure?()
                }
                
        }) { (error: Error?) in
            print("--- failed to get access token")
            self.loginFailure?(error)
            
        }
    }
    
} // TwitterClient
