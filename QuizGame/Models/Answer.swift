import Foundation

struct Answer : Hashable, Codable{
    var id: UUID
    var text: String
    var isCorrect: Bool
}

