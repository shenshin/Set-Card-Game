//
//  ViewController.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var give3MoreCardsButton: UIButton!
    
    var setGame: SetGame = SetGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewsFromModel()
    }
    @IBAction func cardButtonPressed(_ sender: UIButton) {
        guard let index = cardButtons.firstIndex(of: sender) else {return}
        setGame.chooseCard(at: index)
        updateViewsFromModel()
    }
    
    func startNewGame() {
        setGame.startNewGame()
        updateViewsFromModel()
    }
    func updateViewsFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                if index < setGame.inGame.count {
                    cardButtons[index].isEnabled = true
                    cardButtons[index].backgroundColor = #colorLiteral(red: 0.8391417861, green: 0.8392631412, blue: 0.8391153216, alpha: 1)
                    let card = setGame.inGame[index]
                    cardButtons[index].setAttributedTitle(drawSymbol(shape: card.features.shape, color: card.features.color, number: card.features.number, shading: card.features.shading), for: .normal)
                    
                    if setGame.chosenInGameIndices.contains(index) {
                        cardButtons[index].backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                    }
                    
                } else {
                    cardButtons[index].isEnabled = false
                    cardButtons[index].backgroundColor = UIColor.clear
                    cardButtons[index].setAttributedTitle(nil, for: .normal)
                    cardButtons[index].setTitle(nil, for: .normal)
                }
            }
        }
    }
    
    @IBAction func give3MoreCarsButtonPressed(_ sender: UIButton) {
        if setGame.get3MoreCards() {
            updateViewsFromModel()
        }
    }
    @IBAction func startNewGameButtonPressed(_ sender: UIButton) {
        startNewGame()
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

