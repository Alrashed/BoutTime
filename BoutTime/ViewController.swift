//
//  ViewController.swift
//  BoutTime
//
//  Created by Khalid Alrashed on 7/29/17.
//  Copyright © 2017 Khalid Alrashed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var event0Btn: UIButton!
    @IBOutlet weak var event1Btn: UIButton!
    @IBOutlet weak var event2Btn: UIButton!
    @IBOutlet weak var event3Btn: UIButton!
    @IBOutlet weak var nextRoundBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    let game: HistoricalEventGame
    var randomEvents: [Event]
    
    var timer = Timer()
    var secondsLeft = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableEventButtons(false)
        startNewGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.collectionArray(fromFile: "EventsCollection", ofType: "plist")
            let collection = try CollectionUnarchiver.gameCollection(fromArray: array)
            self.game = HistoricalEventGame(collection: collection)
            self.randomEvents = []
        } catch {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }
    
    func startNewGame() {
        game.points = 0
        game.roundsPlayed = 0
        
        nextRound()
    }
    
    func nextRound() {
        randomEvents = game.pickRandomEvents()
        updateEventButtonTitles()
        
        timerLabel.isHidden = false
        messageLabel.isHidden = false
        
        startTimer()
    }
    
    func startTimer () {
        secondsLeft = game.secondsPerRound
        countDown()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    func countDown() {
        let minutes = secondsLeft / 60
        let seconds = secondsLeft % 60
        timerLabel.text = "\(minutes):" + String(format: "%02d", seconds)
        if secondsLeft == 0 {
            checkAnswer()
        } else {
            secondsLeft -= 1
        }
    }
    
    @IBAction func event0DownBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func event1UpBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func event1DownBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func event2UpBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func event2DownBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func event3UpBtn(_ sender: UIButton) {
        
    }
    
    func checkAnswer() {

    }
    
    func updateEventButtonTitles() {
        event0Btn.setTitle(randomEvents[0].name, for: .normal)
        event1Btn.setTitle(randomEvents[1].name, for: .normal)
        event2Btn.setTitle(randomEvents[2].name, for: .normal)
        event3Btn.setTitle(randomEvents[3].name, for: .normal)
    }
    
    func enableEventButtons(_ enabled: Bool) {
        event0Btn.isEnabled = enabled
        event1Btn.isEnabled = enabled
        event2Btn.isEnabled = enabled
        event3Btn.isEnabled = enabled
    }
    
}

