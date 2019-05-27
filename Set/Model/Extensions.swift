//
//  Extensions.swift
//  Set
//
//  Created by Macbook Air on 25.05.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation

extension Array {
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
//    mutating func append(_ newOptional: Element?) {
//        if let element = newOptional {
//            self.append(element)
//        }
//    }
}
