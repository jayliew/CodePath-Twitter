//
//  ViewController.swift
//  Twitter
//
//  Created by Jay Liew on 10/27/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onLogin(_ sender: AnyObject) {
        
        //TwitterClient.sharedInstance?.loginWithBlock(){}
        
        TwitterClient.sharedInstance!.requestSerializer.clearAuthorizationHeader()
        
        TwitterClient.sharedInstance!.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) in
                print("--- GOT access token")
                if let token = requestToken {
                    if let request = token.token {
                        let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request)")
                        UIApplication.shared.open(authURL!)
                        
                    }else{
                        print("--- failed to get access token")
                    }
                }else{
                    print("--- failed to get access token")
                }
                
            }) { (error: Error?) in
                print("--- failed to get access token")
            }
        
        

        
    } // onLogin
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

