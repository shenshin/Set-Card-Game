//
//  Extensions.swift
//  Set
//
//  Created by Macbook Air on 25.05.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation

extension Array {
    
    /// Permutates array.
    ///
    /// - Parameters:
    ///   - taking: Picking item count.
    ///   - withRepetition: Could select an item more than one.
    /// - Returns: Returns permutations.
    public func permutations(taking: Int? = nil, withRepetition: Bool = false) -> [Array] {
        if withRepetition {
            return Combinatorics.permutationsWithRepetitionFrom(self, taking: taking ?? self.count)
        }
        return Combinatorics.permutationsWithoutRepetitionFrom(self, taking: taking ?? self.count)
    }
    
    /// Combinates array.
    ///
    /// - Parameters:
    ///   - taking: Picking item count.
    ///   - withRepetition: Could select an item more than one.
    /// - Returns: Returns combinations.
    public func combinations(taking: Int, withRepetition: Bool = false) -> [Array] {
        if withRepetition {
            return Combinatorics.combinationsWithRepetitionFrom(self, taking: taking)
        }
        return Combinatorics.combinationsWithoutRepetitionFrom(self, taking: taking)
    }

    ///Удаляет и возвращает k последних элементов массива
    ///- Parameter k: число последних элементов массива
    ///- Returns: новый массив из k последних элементов исходного массива
    mutating func extractLast(_ k: Int) -> [Element]? {
        if k > count || k <= 0 {
            return nil
        } else {
            let trailing = suffix(k) //сохраняю последние k элементов массива
            removeLast(k) //удаляю их из исходного массива
            return Array(trailing) //возвращаю массив из сохраненных элементов
        }
    }
}

