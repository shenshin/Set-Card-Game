
import Foundation


enum Parameter {
    enum Value: Int, CaseIterable, CustomStringConvertible {
        case one, two, three
        var description: String {return "\(rawValue)"}
    }
    case shape(Value)
    case color(Value)
    case number(Value)
    case shading(Value)
}
struct SetCard{
    let parameters: [Parameter]
}
let card1 = SetCard(parameters: [.shape(.one), .color(.two), .number(.three), .shading(.one)])
print(card1)
