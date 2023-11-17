//
//  ContentView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 12/11/2023.
//

import SwiftUI

struct CategoryListView: View {
    @ObservedObject var viewModel: QuizGame
    @EnvironmentObject var history: GameHistoryViewModel
    
    @State private var showHistory = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.categories, id: \.id) { category in
                    NavigationLink(destination: GameView(viewModel: viewModel)) {
                        HStack {
                            Image(systemName: category.icon)
                                .foregroundColor(.blue)
                                .imageScale(.large)
                            Text(category.name)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationBarTitle("Quiz Categories", displayMode: .large)
            .toolbar {
                Button() {
                    showHistory = true
                } label: {
                    Image(systemName: "archivebox")
                }
            }
        }
        .sheet(isPresented: $showHistory, content: {
            GameHistoryView(viewModel: history)
        })
    }
}


#Preview() {
    CategoryListView(viewModel: QuizGame())
}
