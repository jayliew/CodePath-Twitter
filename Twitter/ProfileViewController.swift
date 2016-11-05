//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Jay Liew on 11/5/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User.currentUser!
        
        nameLabel.text = user.name
        screenNameLabel.text = user.screen_name
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
