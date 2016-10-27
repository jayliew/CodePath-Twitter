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
    
} // TwitterClient
