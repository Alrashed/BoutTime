//
//  ViewController.swift
//  BoutTime
//
//  Created by Khalid Alrashed on 7/29/17.
//  Copyright © 2017 Khalid Alrashed. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ResultsViewControllerDelegate {
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
            self.randomEvents = game.pickRandomEvents()
        } catch {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResults" {
            let resultsViewController = segue.destination as! ResultsViewController
            resultsViewController.points = game.points
            resultsViewController.delegate = self
        }
    }
    
    func startNewGame() {
        game.points = 0
        game.roundsPlayed = 0
        
        nextRound()
    }
    
    func nextRound() {
        if game.roundsPlayed == game.totalRounds {
            performSegue(withIdentifier: "ShowResults", sender: nil)
        }
        
        randomEvents = game.pickRandomEvents()
        updateEventButtonTitles()
        
        timerLabel.isHidden = false
        messageLabel.isHidden = false
        nextRoundBtn.isHidden = true
        
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
    
    @IBAction func swapTopEvents(_ sender: UIButton) {
        let event0 = randomEvents[0]
        let event1 = randomEvents[1]
        
        randomEvents[0] = event1
        randomEvents[1] = event0
        
        updateEventButtonTitles()
    }
    
    @IBAction func swapMiddleEvents(_ sender: UIButton) {
        let event1 = randomEvents[1]
        let event2  = randomEvents[2]
        
        randomEvents[1] = event2
        randomEvents[2] = event1
        
        updateEventButtonTitles()
    }
    
    @IBAction func swapBottomEvents(_ sender: UIButton) {
        let event2 = randomEvents[2]
        let event3 = randomEvents[3]
        
        randomEvents[2] = event3
        randomEvents[3] = event2
        
        updateEventButtonTitles()
    }
    
    @IBAction func nextRoundButtonTapped(_ sender: UIButton) {
        nextRound()
    }
    
    func playAgainButtonTapped(_ controller: ResultsViewController) {
        startNewGame()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake && timer.isValid == true {
            checkAnswer()
        }
    }
    
    func checkAnswer() {
        game.roundsPlayed += 1
        
        timer.invalidate()
        
        messageLabel.isHidden = true
        timerLabel.isHidden = true
        nextRoundBtn.isHidden = false
        
        if game.checkOrderOfEvents(from: randomEvents) {
            game.points += 1
            
            nextRoundBtn.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
        } else {
            nextRoundBtn.setImage(#imageLiteral(resourceName: "next_round_fail"), for: .normal)
        }
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

