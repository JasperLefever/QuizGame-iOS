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
    @Published var error: QuizApiError?
    
    //mainactor werkt niet??
    func fetchCategories() {
        
        hasError = false
        
        let page = 1
        let perPage = 10
        let endpoint = "categories?page=\(page)&perPage=\(perPage)"
        URLSession.shared.fetchData(endpoint: endpoint) { (result: Result<CategoryResult, QuizApiError>)  in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.categories = data.items!
                case .failure(let error):
                    self.hasError = true
                    self.error = error
                }
            }
        }
        
        
        struct CategoryResult: Codable {
            var metadata : Metadata?
            var items: Array<Category>?
        }
        
    }
    
}