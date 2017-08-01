//
//  ResultsViewController.swift
//  BoutTime
//
//  Created by Khalid Alrashed on 7/31/17.
//  Copyright © 2017 Khalid Alrashed. All rights reserved.
//

import UIKit

protocol ResultsViewControllerDelegate: class {
    func playAgainButtonTapped(_ controller: ResultsViewController)
}

class ResultsViewController: UIViewController {
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    weak var delegate: ResultsViewControllerDelegate?
    var points = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finalScoreLabel.text = "\(points)/6"
    }
    
    @IBAction func playAgainTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        delegate?.playAgainButtonTapped(self)
    }
}
