//
//  SetGame.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation

extension Array {
    ///Удаляет и возвращает k последних элементов массива
    ///- Parameter k: число последних элементов массива
    ///- Returns: новый массив из k последних элементов исходного массива
    mutating func extractLast(_ k: Int) -> [Element]? {
        if k > count {
            return nil
        } else {
            let trailing = suffix(k) //сохраняю последние k элементов массива
            removeLast(k) //удаляю их из исходного массива
            return Array(trailing) //возвращаю массив из сохраненных элементов
        }
    }
}
protocol SetGameDelegate: class {
    func cardsChecked(cards: [Card], isSet: Bool)
    func gameOver()
}

struct SetGame {
    private(set) var deck: [Card] = [] //карты, которые ещё не разыгрывались
    private(set) var matched: [Card] = [] //карты, которые уже были угаданы правильно как сет
    private(set) var inGame: [Card] = [] //карты, которые находятся в данный момент в игре, и из них производится выбор
    private(set) var chosen: [Card] = [] //карты, выбранные, но пока не угаданные как сет

    weak var delegate: SetGameDelegate?

    init(){
        startNewGame()
    }

    mutating func startNewGame() {
        resetDeck()
        matched.removeAll()
        inGame.removeAll()
        chosen.removeAll()
        inGame = deck.extractLast(12)!
        print("В колоде осталось \(deck.count) карт")
    }

    ///Вынимает очередные 3 карты из колоды `deck[]` и помещает их в игру `inGame[]`
    ///- Returns: `true` если удалось поместить 3 новые карты в `inGame[]` и `false` если этого сделать не удалось
    mutating func get3MoreCards() -> Bool {
        if let array = deck.extractLast(3) {
            inGame.append(contentsOf: array)
            return true
        } else {
            return false
        }
    }
    mutating func chooseCard(_ card: Card) -> ([Card], Bool)? {
        if chosen.count < 3 {
            chosen.append(card)
            if chosen.count == 3 {
                if isASet(chosen) {
                    return (chosen, true)
                } else {
                    return (chosen, false)
                }
            }
        }
        return nil
    }
    mutating func chooseCard(_ card: Card) {
        if chosen.count < 3 {
            chosen.append(card)
            if chosen.count == 3 {
                if isASet(chosen) {
                    delegate?.cardsChecked(cards: chosen, isSet: true)
                    removeFromGame(chosen)
                    if !get3MoreCards() {
                        delegate?.gameOver()
                        startNewGame()
                    } else {
                        print("Раздаю ещё три карты")
                        print("В колоде осталось \(deck.count) карт")
                    }
                } else {
                    delegate?.cardsChecked(cards: chosen, isSet: false)
                }
                chosen.removeAll()
            }
        }
    }
    ///Проверяет находятся ли карты в игре, и если да, то удаляет их из игры и перемещает в угаданные
    mutating func removeFromGame(_ cards: [Card]) {
        for card in cards {
            guard let index = inGame.firstIndex(of: card) else {fatalError("Card is not is the game")}
            matched.append(inGame[index])
            inGame.remove(at: index)
        }
    }

    ///Проверяет, являются ли карты `cards` сетом
    func isASet(_ cards: [Card]) -> Bool {
        assert(cards.count == 3, "set (\(cards)) should consist of 3 cards")
        let matrix1 = cards[0].matrix, matrix2 = cards[1].matrix, matrix3 = cards[2].matrix
        var features: [Bool] = []
        for value in matrix1.indices {
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
        //deck.shuffle()
    }
}
