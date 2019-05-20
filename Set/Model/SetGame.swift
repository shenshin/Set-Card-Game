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
