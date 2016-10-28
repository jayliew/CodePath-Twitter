//
//  User.swift
//  
//
//  Created by Jay Liew on 10/27/16.
//
//

import UIKit

class User: NSObject {

    var name: String?
    var screen_name: String?
    var profileUrl: URL?
    var tagline: String?
    
    init(initDictionary: NSDictionary){
        name = initDictionary["name"] as? String
        screen_name = initDictionary["screen_name"] as? String
        tagline = initDictionary["description"] as? String
        
        let profileUrlString = initDictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileUrl = URL(string: profileUrlString)
        }
    } // init
    
} // User
