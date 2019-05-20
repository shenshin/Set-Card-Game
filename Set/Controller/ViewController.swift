//
//  ViewController.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var setGame: SetGame = SetGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        let card1 = Card(shape: .squiggle, color: .red, number: .three, shading: .outlined)
        let card2 = Card(shape: .diamond, color: .green, number: .three, shading: .solid)
        let card3 = Card(shape: .oval, color: .purple, number: .three, shading: .striped)
        let card4 = Card(shape: .squiggle, color: .red, number: .three, shading: .outlined)
        let card5 = Card(shape: .diamond, color: .green, number: .three, shading: .solid)
        let card6 = Card(shape: .squiggle, color: .purple, number: .three, shading: .striped)

        _ = setGame.isASet([card1, card2, card3])
        _ = setGame.isASet([card4, card5, card6])
        
        while let threeCards = setGame.give3moreCards() {
            _ = setGame.isASet(threeCards)
        }
        for card in setGame.matchedCards {
            print(card)
        }
    }


}

