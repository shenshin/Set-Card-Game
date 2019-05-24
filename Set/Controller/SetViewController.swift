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
        updateViewsFromModel()
    }
    func startNewGame() {
        
    }
    func updateViewsFromModel() {
        if cardButtons != nil {
            for buttonIndex in cardButtons.indices {
                for cardIndex in setGame.inGame.indices {
                    
                    if buttonIndex == cardIndex {
                        let button = cardButtons[buttonIndex]
                        let card = setGame.inGame[cardIndex]
                        button.setAttributedTitle(drawSymbol(shape: card.features.shape, color: card.features.color, number: card.features.number, shading: card.features.shading), for: .normal)
                    } else  {
                        //                        let button = cardButtons[buttonIndex]
                        //                        button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
                        //                        button.backgroundColor = UIColor.clear
                    }
                }
            }
        }
    }
    
    @IBAction func give3MoreCarsButtonPressed(_ sender: UIButton) {
    }
    @IBAction func startNewGameButtonPressed(_ sender: UIButton) {
        setGame.startNewGame()
        updateViewsFromModel()
    }
    
    func cardsChecked(cards: [Card], isSet: Bool) {
        print("Chosen cards: \(cards) is Set: \(isSet)")
    }
    func gameOver() {
        print("game over")
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

