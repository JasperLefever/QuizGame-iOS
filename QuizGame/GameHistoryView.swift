//
//  GameHistoryView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 15/11/2023.
//

import SwiftUI

struct GameHistoryView: View {
    @ObservedObject var viewModel: GameHistoryViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.gameHistory) { game in
                VStack(alignment: .leading) {
                    Text("Category: \(game.category)")
                    Text("Score: \(game.score)")
                    Text("Date: \(formatDate(game.date))")
                }
            }
            .navigationBarTitle("Game History")
        }
    }
}


#Preview {
    GameHistoryView(viewModel: GameHistoryViewModel())
}
