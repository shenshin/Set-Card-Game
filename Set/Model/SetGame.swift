//
//  SetGame.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation

struct SetGame {
    var deck: [Card] = []
    init(){
        resetDeck()
        
    }
    //если метод возвращает nil то колода пустая
    mutating func give3moreCards() -> [Card]? {
        if deck.count >= 3 {
            var cards: [Card] = []
            for _ in 1...3 {
                cards.append(deck.removeLast())
            }
            return cards
        } else {
            return nil
        }
    }
    func isASet(_ cards: Card...) -> Bool {
        assert(cards.count == 3, "set should consist of 3 cards")
        var matched = false
        let card1 = cards[0].features
        let card2 = cards[1].features
        let card3 = cards[2].features

        let shapeMatch = card1.shape == card2.shape && card2.shape == card3.shape
        let shapeMissmatch = card1.shape != card2.shape && card2.shape != card3.shape && card3.shape != card1.shape
        let colorMatch = card1.color == card2.color && card2.color == card3.color
        let colorMissmatch = card1.color != card2.color && card2.color != card3.color && card3.color != card1.color
        let numberMatch = card1.number == card2.number && card2.number == card3.number
        let numberMissmatch = card1.number != card2.number && card2.number != card3.number && card3.number != card1.number
        let shadingMatch = card1.shading == card2.shading && card2.shading == card3.shading
        let shadingMissmatch = card1.shading != card2.shading && card2.shading != card3.shading && card3.shading != card1.shading
        if (shapeMatch || shapeMissmatch) && (colorMatch || colorMissmatch) && (numberMatch || numberMissmatch) &&  (shadingMatch || shadingMissmatch) {
            matched = true
        }
        return matched
    }
    private mutating func resetDeck() {
        deck.removeAll()
        /// Не спрашивайте меня как это работает. Это магия.
        func makeLoop(values: [Int], array: [Int] = [], counter: Int = 0) {
            if counter == 4 {
                deck.append(Card(array))
                return
            }
            for value in values {
                makeLoop(values: values, array: array + [value], counter: counter + 1)
            }
        }
        makeLoop(values: [1,2,3])
        //deck.shuffle()
    }
}
extension SetGame: CustomStringConvertible {
    var description: String {
        var string = ""
        for card in deck {
            string += "\(card)\n"
        }
        return string
    }
}
