//
//  GraphicalSetViewController.swift
//  Set
//
//  Created by Ales Shenshin on 03/06/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class GraphicalSetViewController: UIViewController, SetCardViewDelegate {

    @IBOutlet private weak var cardsScreen: SetCardsScreen!
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
            cardsScreen.cardViews.shuffle()
            updateViewsFromModel()
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
                cardsScreen.markCard(with: $0.features, as: .hint)
            }
        }
    }

    func cardTapped(with features: Features) {
        let card = Card(shape: features.shape, color: features.color, number: features.number, shading: features.shading)
        game.updateModel(card)
        updateViewsFromModel()
    }
    func startNewGame() {
        game.startNewGame()
        cardsScreen.subviews.forEach {$0.removeFromSuperview()}
        cardsScreen.cardViews.removeAll()
    
        updateViewsFromModel()
    }

    func dealThreeMoreCards() {
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
            cardsScreen.removeCardFromSuperView(with: removedCard.features)
        }
        // Каждая карта, находящаясь в игре выводится на экран и оформляется в завсимости от обстановки
        for card in game.inGame {
            cardsScreen.markCard(with: card.features, as: .normal) // сбросить ранее установленные оформления
            // Если карты ещё не находится на экране, то создать для неё распознаватель нажатия
            // и добавить на экран
            if let cardView = cardsScreen.addCardToView(with: card.features) {
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
                    cardsScreen.markCard(with: card.features, as: .set)
                // Если карта находится в выбранных и сет не угадан
                } else if game.selected.contains(card) && !matched {
                    cardsScreen.markCard(with: card.features, as: .nonSet)
                }
            // Если попытки угадать сет не производится (не выбрано ещё три карты, то отметить
            // текущую карту как отмеченную
            } else {
                if game.selected.contains(card) {
                    cardsScreen.markCard(with: card.features, as: .selected)
                }
            }
        }
    }
}
