//
//  Card.swift
//  Set
//
//  Created by Ales Shenshin on 20/05/2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation
struct Card {
    let features: Features
    var matrix: [Int] {
        get {
            return [features.shape.rawValue,
                    features.color.rawValue,
                    features.number.rawValue,
                    features.shading.rawValue]
        }
    }
    ///Инициализатор для ручного создания карты
    ///- Parameter shape: Форма символа на карте
    ///- Parameter color: Цвет символа на карте
    ///- Parameter number: Колличество символов на карте
    ///- Parameter shading: Штриховка символа (без заливки, заштрихованный, залитый)
    init(shape: Features.Shape, color: Features.Color, number: Features.Number, shading: Features.Shading) {
        self.features = Features(shape: shape, color: color, number: number, shading: shading)
    }
    ///Инициализатор для автоматического создания карты. Предназначен для метода SetGame.resetDeck() или аналогичных целей
    ///- Parameter features: Массив из четырёх целых чисел от 1 до 3, соответствующих трём возможным значениям четырёх параметров каждой карты
    init(_ features: [Int]) {
        self.features = Features(features: features)
    }
    
}
extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(features.shape)
        hasher.combine(features.color)
        hasher.combine(features.number)
        hasher.combine(features.shading)
    }
}
extension Card: CustomStringConvertible {
    var description: String {
        return "{\(features)}"
    }
}
