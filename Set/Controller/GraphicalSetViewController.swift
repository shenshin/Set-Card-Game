//
//  GraphicalSetViewController.swift
//  Set
//
//  Created by Ales Shenshin on 03/06/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class GraphicalSetViewController: UIViewController, SetCardViewDelegate {

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

    @IBAction func swipeGestureRecognized(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            dealThreeMoreCards()
        default:
            break
        }
    }
    @IBAction func rotationGestureRecognixed(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            print("rotation recognized")
        default:
            break
        }
    }
    
    @IBAction private func give3MoreCarsButtonPressed(_ sender: UIButton) {
        dealThreeMoreCards()
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
    internal func cardTapped(_ card: SetCardView) {
        card.removeFromSuperview()
        setCards.cardViews.removeAll { $0 == card }
    }
    internal func startNewGame() {
        game.startNewGame()
        setCards.subviews.forEach {$0.removeFromSuperview()}
        setCards.cardViews.removeAll()
        
        updateViewsFromModel()
    }
    private func dealThreeMoreCards() {
        game.get3MoreCards()
        updateViewsFromModel()
    }
    private func updateViewsFromModel() {
        
        // приведение кнопки "выдать еще 3 карты" в неактивный режим.
        // кнопка "Give 3 More Cards" нажимается в случаях если колода не пуста и
        //при этом (в игре (на экране) <= 21 карты или последний ход выявил сет)
        give3MoreCardsButton.isEnabled = game.deck.count != 0 && ((game.inGame.count <= 78) || (game.matched != nil && game.matched!)) ? true : false
        
        // обновление поля с информацией о возможном кол-ве сетов и о счёте
        scoreLabel.text = /*"Possible sets: \(game.possibleSets)    */"Score: \(game.score)"
   
        for card in game.inGame {
            
            let cardView = SetCardView(shape: card.features.shape, color: card.features.color, number: card.features.number, shading: card.features.shading)
            let tapGR = UITapGestureRecognizer(target: cardView, action: #selector(SetCardView.tapRecognizedOnCard(by:)))
            tapGR.numberOfTapsRequired = 1
            tapGR.numberOfTouchesRequired = 1
            cardView.addGestureRecognizer(tapGR)
            cardView.delegate = self
            if !setCards.cardViews.contains(cardView) {
                setCards.addSubview(cardView)
                setCards.cardViews.append(cardView)
            }
        }
    }
}
