//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Jay Liew on 11/5/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User.currentUser!
        
        nameLabel.text = user.name
        screenNameLabel.text = user.screen_name
        
        print("--- LOADED PROFILE VIEW CONTROLLER")
        
        if user.profileUrl != nil {
            print("--- profile URL \(user.profileUrl!)")
            profileImageView.setImageWith(user.profileUrl!)
        }else{
            if user.profileUrlInsecure != nil {
                //profileImageView.setImageWith(user.profileUrlInsecure!)
            }
        }
        
        if user.bannerUrl != nil {
            backgroundImageView.setImageWith(user.bannerUrl!)
        }
        
        if user.tagline != nil {
            descriptionLabel.text = user.tagline!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
