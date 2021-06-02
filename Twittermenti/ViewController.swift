//
//  ViewController.swift
//  Twittermenti
//
//  Created by Cody Crawmer on 5/29/21.
//

import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    private let tweetCount = 100
    
    private let sentimentClassifer = TweetSentimentClassifier()
    
    
    // Computed variable to get API Key from plist file
    private var apiKey: String {
        get {
            //1
            guard let filePath = Bundle.main.path(forResource: "Twitter-Info", ofType: "plist") else {
                fatalError("Could not find Twitter-Info.plist")
            }
            //2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find 'API_KEY in 'Twitter-Info.plist'.")
            }
            return value
        }
    }
    
    // Computed Variable to get Secret Api Key
    private var secretApiKey: String {
        get {
            //1
            guard let filePath = Bundle.main.path(forResource: "Twitter-Info", ofType: "plist") else {
                fatalError("Could not find Twitter-Info.plist")
            }
            //2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "SECRET_API_KEY") as? String else {
                fatalError("Couldn't find 'API_KEY in 'Twitter-Info.plist'.")
            }
            return value
        }
    }
    
    
//    let swifter = Swifter(consumerKey: apiKey, consumerSecret: secretApiKey)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
//        let prediction = try! sentimentClassifer.prediction(text: "@Apple is a great company!")
//        print(prediction.label)
        
        

    }

    @IBAction func predictPressed(_ sender: UIButton) {
        fetchTweets()
        
    }
    
    
    func fetchTweets() {
        if let searchText = textField.text {
        
            let swifter = Swifter(consumerKey: apiKey, consumerSecret: secretApiKey)
            
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { results, metadata in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                        }
                }
                
                self.makePredictioin(with: tweets)

            } failure: { error in
                print("There was an error with the Twitter API Request \(error)")
            }
            
        
        

        }
    }
    
    func makePredictioin(with tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try self.sentimentClassifer.predictions(inputs: tweets)
            var sentimentScore = 0
            for pred in predictions {
                let sentiment = pred.label
                
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            
            updateUI(with: sentimentScore)
            
        } catch {
            print("There was an error with the Twitter API Request")
        }
    }
    
    func updateUI(with sentimentScore: Int) {
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😀"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
    

//    func initializeHideKeyboard() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
//    }
//
//    @objc func dismissMyKeyboard() {
//        view.endEditing(true)
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchTweets()
        textField.resignFirstResponder()
        return true
    }
    
    
}
        
    

