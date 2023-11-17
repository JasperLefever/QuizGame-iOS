//
//  QuizGameApp.swift
//  QuizGame
//
//  Created by Jasper Lefever on 12/11/2023.
//

import SwiftUI

@main
struct QuizGameApp: App {
    @StateObject var game: QuizGame = QuizGame()
    var gameHistory = GameHistoryViewModel()
    
    var body: some Scene {
        WindowGroup {
            CategoryListView(viewModel: game)
                .environmentObject(gameHistory)
        }
    }
}
