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
                    Text("Date: \(formattedDate(game.date))")
                }
            }
            .navigationBarTitle("Game History")
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}


#Preview {
    GameHistoryView(viewModel: GameHistoryViewModel())
}
