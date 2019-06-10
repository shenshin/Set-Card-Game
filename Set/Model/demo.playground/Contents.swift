
import Foundation


let sum = [Int](1...100).reduce(into: 0) {$0+=$1}
print(sum)
[Int](1...100).forEach {print($0, terminator: ", ")}
