//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Jay Liew on 10/30/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var charsLeftLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var maxLength = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            if text.isEmpty {
                placeholderLabel.isHidden = false
            }else{
                placeholderLabel.isHidden = true
            }
            let charsLeft = maxLength - text.characters.count
            
            charsLeftLabel.text = "\(charsLeft)"
            if(charsLeft < 0) {
                charsLeftLabel.textColor = UIColor.red
            }else{
                charsLeftLabel.textColor = UIColor.black
            }
        }
    } // textViewDidChange
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    @IBAction func onSubmit(_ sender: AnyObject) {
        guard textView.text.characters.count > 0 && textView.text.characters.count <= 140 else {
            return
        }
        
        let client = TwitterClient.sharedInstance!
        client.postTweet(
            tweet: textView.text,
            success: { () -> ()? in
                print("--- CALLBACK FIRED: SUCCESSFULLY POSTED TWEET: \(self.textView.text)")
                self.dismiss(animated: true)
                return Void()
            },
            failure: { (error: Error?) -> () in
                print("--- FAILURE CALLBACK FIRED: TWEET NOT POSTED: \(self.textView.text)")
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        )
    } // onSubmit
    
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true) {}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
