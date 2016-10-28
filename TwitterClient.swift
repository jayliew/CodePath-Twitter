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
let twitterBaseURL = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    // Singleton
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error?) -> ())?
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error?) -> ()){
        guard let client = TwitterClient.sharedInstance else {
            return
        }
        
        client.get(
            "1.1/statuses/home_timeline.json",
            //"1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: { (progress: Progress) in
                print("--- progress downloading")
            },
            success: { (dataTask: URLSessionDataTask, response: Any?) in
                print("--- SUCCESS GET")
                if let responseArray = response as? [Dictionary <String, Any>]{
                    let tweets = Tweet.tweetsWithArray(dictionaries: responseArray)
                    success(tweets)
                }
            }, // success
            failure: { (dataTask: URLSessionDataTask?, error: Error) in
                print("--- GET FAILURE")
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
                                            print(user)
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
