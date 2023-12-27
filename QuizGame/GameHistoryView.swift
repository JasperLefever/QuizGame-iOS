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
        NavigationStack {
            List {
                ForEach(viewModel.gameHistory) { game in
                    VStack(alignment: .leading) {
                        Text("Category: \(game.category)")
                        Text("Score: \(game.score)")
                        Text("Date: \(formatDate(game.date))")
                    }
                }.onDelete(perform: deleteItem)
            }
            .navigationBarTitle("Game History")
        }
    }
    
    private func deleteItem(at offset: IndexSet) {
        viewModel.removeGameFromHistory(indices: offset)
    }
}




#Preview {
    GameHistoryView(viewModel: GameHistoryViewModel())
}
