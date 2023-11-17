//
//  ContentView.swift
//  BeerApp
//
//  Created by Jasper Lefever on 17/11/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var history: GameHistoryViewModel
    @StateObject var categoriesViewModel = CategoriesViewModel()
    
  var body: some View {
    TabView {
      CategoryListView(viewmodel: categoriesViewModel)
        .tabItem {
          Label("Categories", systemImage: "list.triangle")
        }
      GameHistoryView(viewModel: history)
        .tabItem {
          Label("History", systemImage: "archivebox")
        }
    }

  }

}
