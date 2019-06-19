//
//  GraphicalSetViewController.swift
//  Set
//
//  Created by Ales Shenshin on 03/06/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class GraphicalSetViewController: UIViewController, SetCardViewDelegate {

    @IBOutlet private weak var setCards: SetCardsScreen!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var give3MoreCardsButton: UIButton!
    @IBOutlet weak var hintButton: SetGameButton!
    
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

    @IBAction private func showHint(_ sender: UIButton) {
        if let firstSet = game.sets.first {
            firstSet.prefix(2).forEach {
                setCards.markCard($0, as: .hint)
            }
        }
    }
    internal func cardTapped(_ cardView: SetCardView) {
        let card = cardFromView(cardView)
        game.updateModel(card)
        updateViewsFromModel()
    }
    internal func startNewGame() {
        game.startNewGame()
        setCards.subviews.forEach {$0.removeFromSuperview()}
        setCards.cardViews.removeAll()
    
        updateViewsFromModel()
    }
    private func cardFromView(_ view: SetCardView) -> Card {
        return Card(shape: view.features.shape, color: view.features.color, number: view.features.number, shading: view.features.shading)
    }
    private func dealThreeMoreCards() {
        game.get3MoreCards()
        updateViewsFromModel()
    }
    private func updateViewsFromModel() {
        
        // приведение кнопки "выдать еще 3 карты" в неактивный режим.
        // кнопка "Give 3 More Cards" нажимается в случаях если колода не пуста и
        //при этом (в игре (на экране) <= 78 карты или последний ход выявил сет)
        give3MoreCardsButton.isEnabled = game.deck.count != 0 && ((game.inGame.count <= 78) || (game.matched != nil && game.matched!)) ? true : false
        // кнопка hint (подсказка) неактивна, если доступных сетов не имеется на экране
        hintButton.isEnabled = game.possibleSets == 0 ? false : true
        hintButton.isHighlighted = game.possibleSets == 0 ? true : false //(почему-то не работает)
        // обновление поля с информацией о возможном кол-ве сетов и о счёте
        scoreLabel.text = "Possible sets: \(game.possibleSets)    Score: \(game.score)"
        // Угаданные ранее карты удаляются с экрана
        for removedCard in game.dropout {
            setCards.removeCardFromSuperView(removedCard)
        }
        // Каждая карта, находящаясь в игре выводится на экран и оформляется в завсимости от обстановки
        for card in game.inGame {
            setCards.markCard(card, as: .normal) // сбросить ранее установленные оформления
            // Если карты ещё не находится на экране, то создать для неё распознаватель нажатия
            // и добавить на экран
            if let cardView = setCards.addCardToView(card) {
                let tapGR = UITapGestureRecognizer(target: cardView, action: #selector(SetCardView.tapRecognizedOnCard(by:)))
                tapGR.numberOfTapsRequired = 1
                tapGR.numberOfTouchesRequired = 1
                cardView.addGestureRecognizer(tapGR)
                // Назначить view controller делегатом добавленной карты для того, чтобы метод,
                // обрабатывающий нажатие по карте, находящийся внутри карты, мог сообщить
                // контроллеру, какая именно карта была нажата, передав ссылку на эту карту в
                // метод `func cardTapped(_ cardView: SetCardView)`, который реализован в этом
                // контроллере согласно протоколу SetCardViewDelegate, на который он подписан
                cardView.delegate = self
            }
            // Если в текущем ходе производится попытка угадать сет
            if let matched = game.matched {
                // Если нажатая карта находится в списке выбранных и сет угадан:
                if game.selected.contains(card) && matched {
                    setCards.markCard(card, as: .set)
                // Если карта находится в выбранных и сет не угадан
                } else if game.selected.contains(card) && !matched {
                    setCards.markCard(card, as: .nonSet)
                }
            // Если попытки угадать сет не производится (не выбрано ещё три карты, то отметить
            // текущую карту как отмеченную
            } else {
                if game.selected.contains(card) {
                    setCards.markCard(card, as: .selected)
                }
            }
        }
    }
}
