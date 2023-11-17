//
//  GameHistory.swift
//  QuizGame
//
//  Created by Jasper Lefever on 15/11/2023.
//

import Foundation

struct GameHistory: Identifiable, Codable {
    let id: UUID
    let category: String
    let score: Int
    let date: Date
}

