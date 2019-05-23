//
//  ViewController.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class SetViewController: UIViewController, SetGameDelegate {
    
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var give3MoreCardsButton: UIButton!
    
    var setGame: SetGame = SetGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        setGame.delegate = self
        
    }
    @IBAction func give3MoreCarsButtonPressed(_ sender: UIButton) {
    }
    @IBAction func startNewGameButtonPressed(_ sender: UIButton) {
    }
    
    func cardsChecked(cards: [Card], isSet: Bool) {
        print("Chosen cards: \(cards) is Set: \(isSet)")
    }
    func gameOver() {
        print("game over")
    }
}

