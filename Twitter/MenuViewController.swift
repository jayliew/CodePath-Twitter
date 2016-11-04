//
//  MenuViewController.swift
//  Twitter
//
//  Created by Jay Liew on 11/4/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var viewControllers: [UIViewController] = []
    
    private var homeTimelineNavigationController: UIViewController!
    private var profileNavigationController: UIViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        homeTimelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationViewController")
        
        viewControllers.append(homeTimelineNavigationController)
        
        viewControllers.append(profileNavigationController)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
