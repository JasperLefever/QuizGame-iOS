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
    @Published var showToast = false
    @Published var toastText = ""
    
    func fetchCategories() {
        
        hasError = false
        
        let page = 1
        let perPage = 10
        let endpoint = "categories?page=\(page)&perPage=\(perPage)"
        URLSession.shared.fetchData(endpoint: endpoint) {
            (result: Result<CategoryResult, QuizApiError>) in
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
        
    }
    
    func deleteCategory(at indices: IndexSet) {
        hasError = false
        
        let category = categories[indices.first!]
        
        let endpoint = "categories/\(category.id)"
        
        URLSession.shared.deleteData(at: baseURL, endpoint: endpoint) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.fetchCategories()
                case .failure(let error):
                    self.hasError = true
                    self.error = error
                }
            }
        }
        
    }
    
    func addCategory(name: String, icon: String) {
        hasError = false
        
        let newCategory = RequestCategory(name: name, icon: icon)
        
        let endpoint = "categories"
        
        URLSession.shared.postData(endpoint: endpoint, body: newCategory) {
            (result: Result<Category, QuizApiError>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.fetchCategories()
                    self.showToast = true
                    self.toastText = "Category successfully created"
                case .failure(let error):
                    self.hasError = true
                    self.error = error
                }
            }
        }
        
        struct RequestCategory: Codable {
            let name: String
            let icon: String
        }
    }
    
}
