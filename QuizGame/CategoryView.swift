//
//  ContentView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 12/11/2023.
//

import SwiftUI

struct CategoryListView: View {
    @ObservedObject var viewmodel: CategoriesViewModel
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $path) {
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
                GameView(viewModel: QuizGame(category: category), navigationPath: $path)
            }
        }.onAppear(perform: viewmodel.fetchCategories )
    }
}
