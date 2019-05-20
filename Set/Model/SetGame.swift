//
//  SetGame.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var deck: [Card] = []
    private(set) var matchedCards: [Card] = []

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
    mutating func isASet(_ cards: [Card]) -> Bool {
        assert(cards.count == 3, "set should consist of 3 cards")
        let matrix1 = cards[0].matrix, matrix2 = cards[1].matrix, matrix3 = cards[2].matrix
        var features: [Bool] = []
        for value in matrix1.indices {
            let matched = (matrix1[value] == matrix2[value] && matrix2[value] == matrix3[value]) ||
            (matrix1[value] != matrix2[value] && matrix2[value] != matrix3[value] && matrix1[value] != matrix3[value])
            features.append(matched)
        }
        let result = features.reduce(features[0]) {$0 && $1}
        if result {matchedCards.append(contentsOf: cards)}
        return result
    }
    private mutating func resetDeck() {
        deck.removeAll()
        /// Не спрашивайте меня как это работает. Это магия.
        func makeLoop(values: [Int], array: [Int] = [], counter: Int = 0) {
            //в игре 4 параметра: форма, цвет, число, заливка - поэтому счётчик работает до 4-х
            if counter == 4 {
                deck.append(Card(array))
                return
            }
            for value in values {
                makeLoop(values: values, array: array + [value], counter: counter + 1)
            }
        }
        makeLoop(values: Features.rawValues)
        deck.shuffle()
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
