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
          NavigationLink(destination: GameView(viewModel: gameViewModel)) {
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
    }
  }
}

#Preview() {
  CategoryListView(viewmodel: CategoriesViewModel())
}
