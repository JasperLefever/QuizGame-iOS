//
//  GameHistoryViewModel.swift
//  QuizGame
//
//  Created by Jasper Lefever on 15/11/2023.
//

import SwiftUI

class GameHistoryViewModel: ObservableObject {
    @Published var gameHistory: Array<GameHistory> = []

    init() {
        loadGameHistory()
        addMockData()
    }

    func addGameToHistory(category: String, score: Int, date: Date) {
        let newGame = GameHistory(id: UUID(), category: category, score: score, date: date)
        gameHistory.append(newGame)
        saveGameHistory()
    }

    private func saveGameHistory() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(gameHistory) {
            UserDefaults.standard.set(encoded, forKey: "gameHistory")
        }
    }

    private func loadGameHistory() {
        if let data = UserDefaults.standard.data(forKey: "gameHistory") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([GameHistory].self, from: data) {
                gameHistory = decoded
            }
        }
    }
    
    private func addMockData() {
            let currentDate = Date()
            
            addGameToHistory(category: "History", score: 80, date: currentDate)
            addGameToHistory(category: "Science", score: 90, date: currentDate.addingTimeInterval(-86400))  // One day ago
            addGameToHistory(category: "Geography", score: 75, date: currentDate.addingTimeInterval(-172800))  // Two days ago
        }
}

