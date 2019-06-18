//
//  GraphicalSetViewController.swift
//  Set
//
//  Created by Ales Shenshin on 03/06/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class GraphicalSetViewController: UIViewController {

    @IBOutlet private weak var setCards: SetCards!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var give3MoreCardsButton: UIButton!
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private lazy var game: SetGame = {
        var set = SetGame()
        set.startNewGame()
        return set
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    internal func startNewGame() {
        game.startNewGame()
        setCards.subviews.forEach {$0.removeFromSuperview()}
        setCards.cardViews.removeAll()
        
        updateViewsFromModel()
    }
    
    @IBAction private func give3MoreCarsButtonPressed(_ sender: UIButton) {
        game.get3MoreCards()
        updateViewsFromModel()
    }
    @IBAction private func startNewGameButtonPressed(_ sender: UIButton) {
        startNewGame()
    }
    var index: Int = 0
    @IBAction private func showHint(_ sender: UIButton) {
        index = index > 2 ? 0 : index
//        for card in gameRect.cardViews {
//            card.features.number = SetCardView.Features.Number.allCases[index]
//        }
        index += 1
//        if game.possibleSets > 0 {
//            game.sets.first!.map {game.inGame.firstIndex(of: $0)!}.prefix(2).forEach {
//                _ = $0 //заглушка
//            }
//        }
    }
    
    private func updateViewsFromModel() {
        
        // приведение кнопки "выдать еще 3 карты" в неактивный режим.
        // кнопка "Give 3 More Cards" нажимается в случаях если колода не пуста и
        //при этом (в игре (на экране) <= 21 карты или последний ход выявил сет)
        //            give3MoreCardsButton.isEnabled = game.deck.count != 0 && ((setGame.inGame.count <= 21) || (setGame.matched != nil && setGame.matched!)) ? true : false
        
        // обновление поля с информацией о возможном кол-ве сетов и о счёте
        //scoreLabel.text = "Possible sets: \(game.possibleSets)    Score: \(game.score)"
   
        for card in game.inGame {
            
            let cardView = SetCardView(shape: card.features.shape, color: card.features.color, number: card.features.number, shading: card.features.shading)
            if !setCards.cardViews.contains(cardView) {
                setCards.addSubview(cardView)
                setCards.cardViews.append(cardView)
            }
        }
    }
}
