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
        hasher.combine(matrix)
    }
}
extension Card: CustomStringConvertible {
    var description: String {
        return "{\(features)}\n"
    }
}

struct Features {
    let shape: Shape
    let color: Color
    let number: Number
    let shading: Shading
    
    static var rawValues: [Int] {
        return [Shape.oval.rawValue, Shape.squiggle.rawValue, Shape.diamond.rawValue]
    }

    init(shape: Shape, color: Color, number: Number, shading: Shading) {
        self.shape = shape
        self.color = color
        self.number = number
        self.shading = shading
    }
    init(features: [Int]) {
        assert({()->Bool in
            if features.count != 4 {return false}
            for number in features where !Features.rawValues.contains(number) {return false}
            return true
        }(), "incorrect features")
        self.init(shape: Shape.init(rawValue: features[0])!,
                  color: Color.init(rawValue: features[1])!,
                  number: Number.init(rawValue: features[2])!,
                  shading: Shading.init(rawValue: features[3])!)
    }
    enum Shape: Int, CaseIterable {
        case oval, squiggle, diamond
    }
    enum Color: Int, CaseIterable {
        case red, purple, green
    }
    enum Number: Int, CaseIterable {
        case one, two, three
    }
    enum Shading: Int, CaseIterable {
        case solid, striped, outlined
    }
}

extension Features: CustomStringConvertible {
    var description: String {
        return "shape: \(shape), color: \(color), number: \(number), shading: \(shading)"
    }
}
