//
//  Question.swift
//  QuizGame
//
//  Created by Jasper Lefever on 15/11/2023.
//

import Foundation

struct Question: Hashable, Codable {
    var id: UUID
    var categoryId: UUID
    var question: String
    var answers: [Answer] = []
}
