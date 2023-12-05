//
//  DTOs.swift
//  QuizGame
//
//  Created by Jasper Lefever on 05/12/2023.
//

import Foundation

struct QuestionsResult: Codable {
    var metadata: Metadata?
    var items: [QuestionResult]?
}

struct QuestionResult: Codable {
    var id: UUID
    var category: Category
    var questionText: String
    var answers: [AnswerResult]
}

struct AnswerResult: Codable {
    var id: UUID
    var answerText: String
    var isCorrect: Bool
    var questionId: UUID
}

struct Metadata: Codable {
    var total: Int
    var page: Int
    var per: Int
}


struct CategoryResult: Codable {
    var metadata: Metadata?
    var items: [Category]?
}

struct QuestionRequest: Codable {
    var categoryId: UUID
    var questionText: String
    var answers: [AnswerRequest] = []
}

struct AnswerRequest: Codable {
    var answerText: String
    var isCorrect: Bool
}
