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

    /// Инициалирует карту 4-мя параметрами, принимающими три возможных значения
    /// - Parameter shape: Форма символа на карте
    /// - Parameter color: Цвет символа на карте
    /// - Parameter number: Колличество символов на карте
    /// - Parameter shading: Штриховка символа (без заливки, заштрихованный, залитый)
    init(shape: Features.Shape, color: Features.Color, number: Features.Number, shading: Features.Shading) {
        self.features = Features(shape: shape, color: color, number: number, shading: shading)
    }
    init(_ features: Features) {
        self.features = features
    }
}
extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(features)
    }
}
extension Card: CustomStringConvertible {
    var description: String {
        return "{\(features)}"
    }
}
