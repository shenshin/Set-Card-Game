
import Foundation

let ints = [Int](1...10)
let reduce1 = ints.reduce(into: Double(ints.first!)) {$0*=Double($1)}
let reduce2 = ints.reduce(Double(ints.first!)) {$0*Double($1)}
let newInts = ints.compactMap {$0 != 5 ? $0 : nil}
let newInts2 = ints.filter {$0 != 5}
print(newInts)
print(newInts2)
print(reduce1)
print(reduce2)
