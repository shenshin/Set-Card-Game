//
//  Combinatorics.swift
//  Set
//
//  Created by Ales Shenshin on 29.05.2019.
//  Copyright © 2019 Ales Shenshin. All rights reserved.
//

import Foundation

/// Combinatorics contains static functions to generate k-permutations and k-combinations
/// (in both cases either with or without repetition) of the n elements in an array.
public struct Combinatorics {
    
    // MARK: - Permutations
    /// Given an array of elements and how many of them we are taking, returns an array with all possible permutations
    /// without repetition. Please note that as repetition is not allowed, taking must always be less or equal to
    /// `elements.count`.
    /// Almost by convention, if `taking` is 0, the function will return [[]] (an array with only one possible permutation
    /// - a permutation with no elements). In a different scenario, if `taking` is bigger than `elements.count` the function
    /// will return [] (an empty array, so including no permutation at all).
    ///
    /// - Parameters:
    ///   - elements: Array to be permutating.
    ///   - taking: Picking item count from array.
    /// - Returns: Returns permutations of elements without repetition.
    public static func permutationsWithoutRepetitionFrom<T>(_ elements: [T], taking: Int) -> [[T]] {
        guard elements.count >= taking else { return [] }
        guard elements.count >= taking && taking > 0 else { return [[]] }
        
        if taking == 1 {
            return elements.map {[$0]}
        }
        
        var permutations = [[T]]()
        for (index, element) in elements.enumerated() {
            var reducedElements = elements
            reducedElements.remove(at: index)
            permutations += permutationsWithoutRepetitionFrom(reducedElements, taking: taking - 1).map {[element] + $0}
        }
        
        return permutations
    }
    
    /// Given an array of elements and how many of them we are taking, returns an array with all possible permutations
    /// with repetition. Please note that as repetition is allowed, taking does not need to be less or equal to
    /// `elements.count`.
    /// Almost by convention, if `taking` is 0, the function will return [[]] (an array with only one possible permutation
    /// - a permutation with no elements). In a different scenario, if `taking` is bigger than 0 but elements contains no
    /// elements, the function will return [] (an empty array, so including no permutation at all).
    ///
    /// - Parameters:
    ///   - elements: Array to be permutating.
    ///   - taking: Picking item count from array.
    /// - Returns: Returns permutations of elements with repetition.
    public static func permutationsWithRepetitionFrom<T>(_ elements: [T], taking: Int) -> [[T]] {
        guard elements.count >= 0 && taking > 0 else { return [[]] }
        
        if taking == 1 {
            return elements.map {[$0]}
        }
        
        var permutations = [[T]]()
        for element in elements {
            permutations += permutationsWithRepetitionFrom(elements, taking: taking - 1).map {[element] + $0}
        }
        
        return permutations
    }
    
    // MARK: - Combinations
    /// Given an array of elements and how many of them we are taking, returns an array with all possible combinations
    /// without repetition. Please note that as repetition is not allowed, taking must always be less or equal to
    /// `elements.count`.
    /// Almost by convention, if `taking` is 0, the function will return [[]] (an array with only one possible combination
    /// - a combination with no elements). In a different scenario, if taking is bigger than `elements.count` the function
    /// will return [] (an empty array, so including no combination at all).
    ///
    /// - Parameters:
    ///   - elements: Array to be combinating.
    ///   - taking: Picking item count from array
    /// - Returns: Returns combinations of elements without repetition.
    public static func combinationsWithoutRepetitionFrom<T>(_ elements: [T], taking: Int) -> [[T]] {
        guard elements.count >= taking else { return [] }
        guard elements.count > 0 && taking > 0 else { return [[]] }
        
        if taking == 1 {
            return elements.map {[$0]}
        }
        
        var combinations = [[T]]()
        for (index, element) in elements.enumerated() {
            var reducedElements = elements
            reducedElements.removeFirst(index + 1)
            combinations += combinationsWithoutRepetitionFrom(reducedElements, taking: taking - 1).map {[element] + $0}
        }
        
        return combinations
    }
    
    /// Given an array of elements and how many of them we are taking, returns an array with all possible combinations
    /// with repetition. Please note that as repetition is allowed, taking does not need to be less or equal to
    /// `elements.count`.
    /// Almost by convention, if `taking` is 0, the function will return [[]] (an array with only one possible
    /// combination - a combination with no elements). In a different scenario, if `taking` is bigger than 0 but
    /// elements contains no elements, the function will return [] (an empty array, so including no combination at all).
    ///
    /// - Parameters:
    ///   - elements: Array to be combinating.
    ///   - taking: Picking item count from array
    /// - Returns: Returns combinations of elements with repetition.
    public static func combinationsWithRepetitionFrom<T>(_ elements: [T], taking: Int) -> [[T]] {
        guard elements.count >= 0 && taking > 0 else { return [[]] }
        
        if taking == 1 {
            return elements.map {[$0]}
        }
        
        var combinations = [[T]]()
        var reducedElements = elements
        for element in elements {
            combinations += combinationsWithRepetitionFrom(reducedElements, taking: taking - 1).map {[element] + $0}
            reducedElements.removeFirst()
        }
        
        return combinations
    }
}
