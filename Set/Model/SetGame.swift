//
//  SetGame.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation

struct SetGame {
    /// Карты, которые ещё не разыгрывались
    private(set) var deck: [Card] = []
    /// Карты, которые находятся в данный момент в игре, и из них производится выбор
    private(set) var inGame: [Card] = []
    /// Карты, выбранные, но пока не угаданные как сет
    private(set) var selected: [Card] = []
    /// Карты, уже выбывшие из игры, то есть угаданные на предыдущих ходах
    private(set) var dropout: [Card] = []
    /// Был ли угадан сет в предыдущем ходе?
    var matched: Bool? {
        return selected.count == 3 ? isASet(selected) ? true : false : nil
    }
    private(set) var score: Int = 0
    /// Коллекция 3-карточных массивов, составляющих сет на данный момент игры
    var sets: [[Card]] {
        return inGame.combinations(taking: 3).filter{isASet($0)}
    }
    /// Количество возможных сетов среди карт, находящихся в игре
    var possibleSets: Int {
        return inGame.combinations(taking: 3).reduce(into: 0){$0 += isASet($1) ? 1 : 0}
    }
    /// Сбрасывает все параметры для начала новой игры
    mutating func startNewGame() {
        resetDeck()
        inGame.removeAll()
        selected.removeAll()
        score = 0
        inGame = deck.extractLast(12)!
    }

    /// Вынимает очередные 3 карты из колоды `deck[]` и помещает их в игру `inGame[]`
    /// - Returns: `true` если удалось поместить 3 новые карты в `inGame[]` и `false` если этого сделать не удалось
    mutating func get3MoreCards() {
        if let array = deck.extractLast(3) {
            inGame.append(contentsOf: array)
            updateModel()
        }
    }
    /// Принимает по одной карте, выбираемые пользователем и формирует модель игры.
    /// Если в параметре передаётся `nil`, то метод только обнуляет выбранные
    /// на данный момент карты и, при удачно угаданном сете, удаляет выбранные карты
    /// из игры.
    /// - Parameter optionalCard: Новая карта, передаваемая модели на обработку, либо
    /// `nil` если требуется просто обновить состояние модели, например,
    /// после удачно или неудачно угаданного сета.
    mutating func updateModel(_ optionalCard: Card? = nil) {
        assert(selected.count <= 3, "The ammount of chosen cards is greater than possible")
        //если метод в аргументе получает карту
        if let card = optionalCard {
            //в предыдущем ходе не было попытки угадать сет
            if matched == nil {
                //если карта уже выбрана, удалить ее из выбранных
                if selected.contains(card) {
                    selected.removeAll { $0 == card }
                    score -= 1 // штраф за снятие выбора с карты
                //а если не была выбрана, то добавить в выбранные
                } else {
                    selected.append(card)
                    if selected.count == 3 {
                        score += isASet(selected) ? 3 : -5 //начисление очков в счёт
                    }
                }
            //в предыдущем ходе был угадан сет
            } else if matched! {
                dropout.append(contentsOf: selected) //удаляемые из игры карты поместить в "выбывшие"
                let temp = selected
                //из игры удаляются выбранные карты
                selected.forEach { match in inGame.removeAll { $0 == match } }
                selected.removeAll()
                
                //если при вызове метода была передана новая карта, не входящая
                //в уже угаданный сет, то она добавляется во вновь выбранные карты
                //после их предшествующего обнуления
                if !temp.contains(card) {
                    selected.append(card)
                }
            //если в предыдущем ходе карты не составили сет, то обнулить выбранные
            //карты и добавить переданную карту в выбранные
            } else {
                selected.removeAll()
                selected.append(card)
            }
        //Если в аргументе функции не была передана карта
        } else {
            //если в предыдущем ходе был угадан сет, но метод вызван без передачи
            //выбранной карты, то удалить удачно угаданные карты из игры
            if let match = matched {
                if match {
                    dropout.append(contentsOf: selected) //удаляемые из игры карты поместить в "выбывшие"
                    selected.forEach { match in inGame.removeAll { $0 == match } }
                    selected.removeAll()
                } else {
                    selected.removeAll()
                }
            }
        }
    }

//    func isASet(_ cards: [Card]) -> Bool {
//        assert(cards.count == 3, "set (\(cards)) should consist of 3 cards")
//        return cards.reduce(into: true) { (result, card) in
//            //card.features.forEach()
//        }
//    }
    /// Проверяет, являются ли карты `cards` сетом
    func isASet(_ cards: [Card]) -> Bool {
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
        deck = Combinatorics.permutationsWithRepetitionFrom(Features.rawValues, taking: 4).map {
            Card(shape: Features.Shape(rawValue: $0[0])!,
                 color: Features.Color(rawValue: $0[1])!,
                 number: Features.Number(rawValue: $0[2])!,
                 shading: Features.Shading(rawValue: $0[3])!)
        }
        deck.shuffle()
    }

}



//        // Моя собственная версия алгоритма перестановок с повторениями.
//        // Реализация аналогична выполненной в struct Combinatorics
//        func makeLoop(values: [Int], array: [Int] = [], counter: Int = 0) {
//            //в игре 4 параметра: форма, цвет, число, заливка - поэтому счётчик работает до 4-х
//            if counter == 4 {
//                deck.append(Card(array))
//                return
//            }
//            for value in values {
//                makeLoop(values: values, array: array + [value], counter: counter + 1)
//            }
//        }
//        makeLoop(values: Features.rawValues)
//        assert(deck.count == 81, "Deck was not created")
//        deck.shuffle()
