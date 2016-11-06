//
//  User.swift
//
//
//  Created by Jay Liew on 10/27/16.
//
//

import UIKit

class User: NSObject {
    
    // Stored properties
    var name: String?
    var screen_name: String?
    var profileUrl: URL?
    var profileUrlInsecure: URL?
    var bannerUrl: URL?
    var backgroundUrl: URL?
    var backgroundUrlInsecure: URL?
    var tagline: String?
    var following: Int?
    var followersCount: Int?
    var statusesCount: Int?
    
    var dictionary : Dictionary<String, Any>? // raw data for User
    
    static var _currentUser: User?
    static let userDidLogoutNotification = "UserDidLogout"
    
    // Computed property
    class var currentUser: User? {
        get {
            if _currentUser == nil { // if there's no current user
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    if let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as? NSDictionary {
                        _currentUser = User(initDictionary: dictionary)
                    }else{
                        print("---!!! can't serialize current user from defaults")
                    }
                }else{
                    print("--- no current user in defaults")
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            print("--- setting user: ")
            
            let defaults = UserDefaults.standard
            if let user = user {
                // using JSONSerialization to avoid using NSCoding
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            }else{
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
        
    } // currentUser
    
    init(initDictionary: NSDictionary){
        print(initDictionary)
        
        self.dictionary = initDictionary as? Dictionary
        name = initDictionary["name"] as? String
        screen_name = initDictionary["screen_name"] as? String
        tagline = initDictionary["description"] as? String
        
        let profileUrlString = initDictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileUrl = URL(string: profileUrlString)
        }

        let profileUrlStringInsecure = initDictionary["profile_image_url"] as? String
        if let profileUrlStringInsecure = profileUrlStringInsecure{
            profileUrlInsecure = URL(string: profileUrlStringInsecure)
            
        }

        let bannerUrlString = initDictionary["profile_banner_url"] as? String
        if let bannerUrlString = bannerUrlString{
            bannerUrl = URL(string: bannerUrlString)
        }
        
        if let sC = initDictionary["statuses_count"] as? Int {
            statusesCount = sC
        }
        
        //if let fCount = initDictionary["followers_count"] as? Int {
        if let fCount = initDictionary["followers_count"] as? Int {
           followersCount = fCount
        }

        if let fIng = initDictionary["friends_count"] as? Int {
            following = fIng
        }

        if let sC = initDictionary["statuses_count"] as? Int {
            statusesCount = sC
        }
        
    } // init
    
} // User
