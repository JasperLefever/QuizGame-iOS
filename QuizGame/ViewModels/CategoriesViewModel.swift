//
//  CategoriesViewModel.swift
//  QuizGame
//
//  Created by Jasper Lefever on 17/11/2023.
//

import SwiftUI

class CategoriesViewModel: ObservableObject {
    
    @Published var categories: [Category] = []
    @Published var hasError = false
    @Published var error: Error?
    
    
    private static let cat: [Category] = [
        Category( name: "Technology", icon: "gear"),
        Category( name: "Science", icon: "atom"),
        Category(name: "Travel", icon: "airplane"),
        Category( name: "Food", icon: "fork.knife"),
        Category( name: "Music", icon: "music.note"),
    ]
    
    @MainActor
    func fetchCategories() {
        let page = 1
        let perPage = 10
        let endpoint = "categories?page=\(page)&perPage=\(perPage)"
        URLSession.shared.fetchData(endpoint: endpoint) { (result: Result<CategoryResult, Error>)  in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.categories = data.items!
                case .failure(let error):
                    // error handle
                    self.hasError = true
                    self.error = error
                }
            }
        }
        
        
        struct CategoryResult: Codable {
            var metadata : Metadata?
            var items: Array<Category>?
        }
        
        struct Metadata : Codable {
            var total: Int
            var page: Int
            var per: Int
        }
    }
    
    func selectCategory(_ category: Category) {
        //gamemodel.selectCategory(category)
    }
    
}
