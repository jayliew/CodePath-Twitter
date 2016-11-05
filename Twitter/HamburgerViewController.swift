//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Jay Liew on 11/4/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewLeading: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }

    var contentViewController: UIViewController! {
        didSet (oldContentViewController){
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, animations: {
                    self.contentViewLeading.constant = 0
                    self.view.layoutIfNeeded()
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMargin = contentViewLeading.constant
        }else if sender.state == .changed {
            
            contentViewLeading.constant = originalLeftMargin + translation.x
            
        }else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.5, animations: {
                if velocity.x > 0 {
                    self.contentViewLeading.constant =  self.view.frame.size.width - 50
                }else{
                    self.contentViewLeading.constant = 0
                }
                self.view.layoutIfNeeded() 
            }) // animate
        } // .ended
    } // onPanGesture

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
