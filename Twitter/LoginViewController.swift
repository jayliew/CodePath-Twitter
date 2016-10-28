//
//  ViewController.swift
//  Twitter
//
//  Created by Jay Liew on 10/27/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onLogin(_ sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        
        client?.login(
            success: {
                () -> () in
                print("--- onLogin SSUUUCCCESSSSSSSSS CALLBACK - LOGIN AUTOMATICALLY")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            },
            failure: { (error: Error?) in
                print(error?.localizedDescription)
        })
    } // onLogin
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

