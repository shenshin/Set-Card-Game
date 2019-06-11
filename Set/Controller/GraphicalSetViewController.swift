//
//  GraphicalSetViewController.swift
//  Set
//
//  Created by Ales Shenshin on 03/06/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class GraphicalSetViewController: UIViewController {

    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var give3MoreCardsButton: UIButton!
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private lazy var setGame: SetGame = SetGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    func startNewGame() {
        setGame.startNewGame()
        updateViewsFromModel()
    }
    
    
    @IBAction private func give3MoreCarsButtonPressed(_ sender: UIButton) {
        setGame.get3MoreCards()
        updateViewsFromModel()
    }
    @IBAction private func startNewGameButtonPressed(_ sender: UIButton) {
        startNewGame()
    }
    @IBAction private func showHint(_ sender: UIButton) {
        if setGame.possibleSets > 0 {
            setGame.sets.first!.map {setGame.inGame.firstIndex(of: $0)!}.prefix(2).forEach {
                _ = $0 //заглушка
            }
        }
    }
    
    private func updateViewsFromModel() {
        
        // приведение кнопки "выдать еще 3 карты" в неактивный режим.
        // кнопка "Give 3 More Cards" нажимается в случаях если колода не пуста и
        //при этом (в игре (на экране) <= 21 карты или последний ход выявил сет)
        //            give3MoreCardsButton.isEnabled = setGame.deck.count != 0 && ((setGame.inGame.count <= 21) || (setGame.matched != nil && setGame.matched!)) ? true : false
        
        // обновление поля с информацией о возможном кол-ве сетов и о счёте
        scoreLabel.text = "Possible sets: \(setGame.possibleSets)    Score: \(setGame.score)"
        
        
        
    }
}
