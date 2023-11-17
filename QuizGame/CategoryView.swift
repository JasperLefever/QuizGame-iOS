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
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewmodel.categories, id: \.id) { category in
                    NavigationLink(destination: GameView(viewModel: gameViewModel).onAppear(perform: {
                        gameViewModel.select(category: category)
                        gameViewModel.fetchQuestions()
                    })) {
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
            .navigationBarTitle("Quiz Categories", displayMode: .large)
        }.onAppear(perform: viewmodel.fetchCategories )
    }
}
