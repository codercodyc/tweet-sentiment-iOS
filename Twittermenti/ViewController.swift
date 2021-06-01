//
//  ViewController.swift
//  Twittermenti
//
//  Created by Cody Crawmer on 5/29/21.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let swifter = Swifter(consumerKey: consumerApiKey, consumerSecret: consumerApiSecretKey)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func predictPressed(_ sender: UIButton) {
        
    }
    
}

