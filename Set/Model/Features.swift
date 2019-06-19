//
//  Features.swift
//  Set
//
//  Created by Ales Shenshin on 17.06.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation

struct Features {
    enum Color: Int, CaseIterable { case green, purple, red }
    enum Shape: Int, CaseIterable { case squiggle, diamond, oval }
    enum Number: Int, CaseIterable { case one, two, three }
    enum Shading: Int, CaseIterable { case solid, outlined, striped }
    init(shape: Shape = Shape.oval, color: Color = Color.red, number: Number = Number.three, shading: Shading = Shading.striped) {
        self.shape = shape; self.color = color; self.number = number; self.shading = shading
    }
    var color: Color
    var shape: Shape
    var number: Number
    var shading: Shading

    /// Цифровые значения параметров. Определяются по значениям для enum Shape.
    /// Нужны для использования их в алгоритмах комбинаторики
    static var rawValues: [Int] {
        return [Shape.oval.rawValue, Shape.squiggle.rawValue, Shape.diamond.rawValue]
    }

}
extension Features: Hashable, Equatable {
    static func == (lhs: Features, rhs: Features) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(shape)
        hasher.combine(number)
        hasher.combine(shading)
    }
}
extension Features: CustomStringConvertible {
    var description: String {
        return "shape: \(shape), color: \(color), number: \(number), shading: \(shading)"
    }
}
