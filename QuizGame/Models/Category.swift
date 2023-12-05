//
//  Category.swift
//  QuizGame
//  MODEL category
//  Created by Jasper Lefever on 15/11/2023.
//

import Foundation

struct Category: Hashable, Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var icon: String
    var questionCount: Int?
}
