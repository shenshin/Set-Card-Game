
import Foundation

let ints: [Int] = Array(1...10)

let newInts = ints.compactMap {$0 != 5 ? $0 : nil}
let newInts2 = ints.filter {$0 != 5}
print(newInts)
print(newInts2)
