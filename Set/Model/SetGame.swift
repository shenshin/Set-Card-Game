//
//  SetGame.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation

struct SetGame {
    ///Карты, которые ещё не разыгрывались
    private(set) var deck: [Card] = []
    ///Карты, которые находятся в данный момент в игре, и из них производится выбор
    private(set) var inGame: [Card] = []
    ///Карты, выбранные, но пока не угаданные как сет
    private(set) var chosen: [Card] = []
    ///Был ли угадан сет в предыдущем ходе?
    private(set) var matched: Bool?

    init(){
        startNewGame()
    }

    mutating func startNewGame() {
        resetDeck()
        inGame.removeAll()
        chosen.removeAll()
        inGame = deck.extractLast(12)!
    }

    ///Вынимает очередные 3 карты из колоды `deck[]` и помещает их в игру `inGame[]`
    ///- Returns: `true` если удалось поместить 3 новые карты в `inGame[]` и `false` если этого сделать не удалось
    mutating func get3MoreCards() {
        if inGame.count <= 21 {
            if let array = deck.extractLast(3) {
                inGame.append(contentsOf: array)
            }
        }
    }

    mutating func chooseCard(_ card: Card) {
        assert(chosen.count <= 3, "The ammount of chosen cards is greater than possible")
        //в предыдущем ходе не было попытки угадать сет
        if matched == nil {
            if chosen.contains(card) {
                chosen.removeAll { $0 == card }
            } else {
                chosen.append(card)
                if chosen.count == 3 {
                    matched = isASet(chosen)
                }
            }
        //в предыдущем ходе был угадан сет
        } else if matched! {
            let temp = chosen
            chosen.forEach { match in inGame.removeAll { $0 == match } }
            chosen.removeAll()
            matched = nil
            if !temp.contains(card) {
                chosen.append(card)
            }
            get3MoreCards()
        //в предыдущем ходе карты не составили сет
        } else {
            chosen.removeAll()
            matched = nil
            chosen.append(card)
        }
    }
    
    ///Проверяет, являются ли карты `cards` сетом
    private func isASet(_ cards: [Card]) -> Bool {
        assert(cards.count == 3, "set (\(cards)) should consist of 3 cards")
        let matrix1 = cards[0].matrix, matrix2 = cards[1].matrix, matrix3 = cards[2].matrix

        var features: [Bool] = []
        for value in matrix1 {
            let matched = (matrix1[value] == matrix2[value] && matrix2[value] == matrix3[value]) ||
            (matrix1[value] != matrix2[value] && matrix2[value] != matrix3[value] && matrix1[value] != matrix3[value])
            features.append(matched)
        }
        let result = features.reduce(features[0]) {$0 && $1}
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
        assert(deck.count == 81, "Deck was not created")
        deck.shuffle()
    }
}
