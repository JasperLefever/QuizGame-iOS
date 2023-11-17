//
//  CategoriesViewModel.swift
//  QuizGame
//
//  Created by Jasper Lefever on 17/11/2023.
//

import SwiftUI

class CategoriesViewModel: ObservableObject {

  var categories: [Category]

  private static let cat: [Category] = [
    Category( name: "Technology", icon: "gear"),
    Category( name: "Science", icon: "atom"),
    Category(name: "Travel", icon: "airplane"),
    Category( name: "Food", icon: "fork.knife"),
    Category( name: "Music", icon: "music.note"),
  ]

  init() {
      self.categories = CategoriesViewModel.cat
  }

  func selectCategory(_ category: Category) {
    //model.selectCategory(category)
  }

}
