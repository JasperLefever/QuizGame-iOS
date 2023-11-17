//
//  ContentView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 12/11/2023.
//

import SwiftUI

struct CategoryListView: View {
    @ObservedObject var viewmodel: CategoriesViewModel
    @StateObject var gameViewModel = QuizGame()
    @State var gameIsActive = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewmodel.categories, id: \.id) { category in
                    NavigationLink(value: category) {
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
            .alert(isPresented: $viewmodel.hasError,error: viewmodel.error, actions: {
                Button(action: viewmodel.fetchCategories, label: {
                    Text("Retry")
                })
            })
            .navigationTitle("Quiz Categories")
            .navigationDestination(for: Category.self) { category in
                GameView(viewModel: gameViewModel)
                    .onAppear(perform: {
                        gameViewModel.select(category: category)
                        gameViewModel.fetchQuestions()
                    }
            )}
        }.onAppear(perform: viewmodel.fetchCategories )
    }
}
