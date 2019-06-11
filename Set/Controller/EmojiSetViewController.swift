//
//  ViewController.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class EmojiSetViewController: UIViewController {
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var give3MoreCardsButton: UIButton!

    private lazy var setGame: SetGame = SetGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }

    func startNewGame() {
        setGame.startNewGame()
        updateViewsFromModel()
    }

    @IBAction private func cardButtonPressed(_ sender: UIButton) {
        guard let index = cardButtons.firstIndex(of: sender) else {fatalError("Wrong card index")}
        setGame.updateModel(setGame.inGame[index])
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
                cardButtons[$0].backgroundColor = #colorLiteral(red: 0.7338971496, green: 0.8800854087, blue: 0.9710964561, alpha: 1)
            }
        }
    }
    
    private func updateViewsFromModel() {
        if cardButtons != nil {
            // приведение кнопки "выдать еще 3 карты" в неактивный режим.
            // кнопка "Give 3 More Cards" нажимается в случаях если колода не пуста и
            //при этом (в игре (на экране) <= 21 карты или последний ход выявил сет)
            give3MoreCardsButton.isEnabled = setGame.deck.count != 0 && ((setGame.inGame.count <= 21) || (setGame.matched != nil && setGame.matched!)) ? true : false
            
            // обновление поля с информацией о возможном кол-ве сетов и о счёте
            scoreLabel.text = "Possible sets: \(setGame.possibleSets) | Score: \(setGame.score)"
            
            // обновление кнопок с изображениями карт
            for index in cardButtons.indices {
                let button = cardButtons[index]
                if index < setGame.inGame.count {
                    button.isEnabled = true
                    button.backgroundColor = #colorLiteral(red: 0.9085996184, green: 0.9198168977, blue: 0.9198168977, alpha: 1)
                    let card = setGame.inGame[index]
                    button.setAttributedTitle(drawSymbol(shape: card.features.shape, color: card.features.color, number: card.features.number, shading: card.features.shading), for: .normal)
                    if let matched = setGame.matched {
                        if setGame.chosen.contains(card) && matched {
                            button.backgroundColor = #colorLiteral(red: 0.8394593306, green: 1, blue: 0.8707115997, alpha: 1)
                        } else if setGame.chosen.contains(card) && !matched {
                            button.backgroundColor = #colorLiteral(red: 0.9879103513, green: 0.8457199425, blue: 0.916779121, alpha: 1)
                        }
                    } else {
                        if setGame.chosen.contains(card) {
                            button.backgroundColor = #colorLiteral(red: 1, green: 0.960983851, blue: 0.8528137015, alpha: 1)
                        }
                    }
                } else {
                    button.isEnabled = false
                    button.backgroundColor = UIColor.clear
                    button.setAttributedTitle(nil, for: .normal)
                    button.setTitle(nil, for: .normal)
                }
            }
        }
    }

    private func drawSymbol(shape: Features.Shape, color: Features.Color, number: Features.Number, shading: Features.Shading) -> NSMutableAttributedString {
        var generalAttributes: [NSAttributedString.Key: Any] {
            let font = UIFont.systemFont(ofSize: 22, weight: .medium)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            return [.paragraphStyle: paragraphStyle,
                    .font: font]
        }
        var symbolShape: String {
            switch shape {
            case .diamond: return "▲"
            case .oval: return "●"
            case .squiggle: return "■"
            }
        }
        var symbolColor: UIColor {
            switch color {
            case .green: return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            case .purple: return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            case .red: return #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }
        var symbolShading: [NSAttributedString.Key: Any] {
            switch shading {
            case .outlined: return [.foregroundColor: symbolColor.withAlphaComponent(1),
                                    .strokeWidth: 7]
            case .solid: return [.foregroundColor: symbolColor.withAlphaComponent(1),
                                 .strokeWidth: -3]
            case .striped: return [.foregroundColor: symbolColor.withAlphaComponent(0.2),
                                   .strokeWidth: -3]
            }
        }
        var symbolNumber: Int {
            switch number {
            case .one: return 1
            case .two: return 2
            case .three: return 3
            }
        }
        var symbol: String {
            var string = String(repeating: "\(symbolShape)\n", count: symbolNumber)
            string.removeLast()
            return string
        }
        let range = NSRange(location: 0, length: symbol.count)
        let attrString = NSMutableAttributedString(string: symbol)
        attrString.addAttributes(generalAttributes, range: range)
        attrString.addAttributes(symbolShading, range: range)
        attrString.addAttribute(.strokeColor, value: symbolColor, range: range)
        return attrString
    }
}

