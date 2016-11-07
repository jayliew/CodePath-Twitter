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
    private var mentionsTimelineNavigationController: UINavigationController!
    private var profileNavigationController: UIViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    var menuLabels = ["Home", "Profile", "Mentions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        homeTimelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        viewControllers.append(homeTimelineNavigationController)
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationViewController")
        viewControllers.append(profileNavigationController)

        mentionsTimelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        
        let mentionsVC = mentionsTimelineNavigationController.topViewController as! TweetsViewController
        mentionsVC.mentionsTimelineEnabled = true
        viewControllers.append(mentionsTimelineNavigationController)

        hamburgerViewController.contentViewController = homeTimelineNavigationController // set as default content on first load up
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.menuLabel.text = menuLabels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
