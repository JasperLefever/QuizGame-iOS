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
    }

    private func loadGameHistory() {
        if let data = UserDefaults.standard.data(forKey: "gameHistory") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([GameHistory].self, from: data) {
                gameHistory = decoded
            }
        }
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
    
}

