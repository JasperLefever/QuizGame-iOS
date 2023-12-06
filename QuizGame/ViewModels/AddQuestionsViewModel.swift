//
//  AddQuestionsView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 05/12/2023.
//

import SwiftUI

class AddQuestionViewModel: ObservableObject {
    
    @Published var questionText: String = ""
    @Published var incorrectAnswers: [String] = ["", ""]
    @Published var correctAnswer: String = ""
    @Published var categories: [Category] = []
    @Published var hasError = false
    @Published var error: QuizApiError?
    @Published var selectedCategory: Category? = nil
    
    init() {
        fetchCategories()
    }
    
    func saveQuestion() {
        let answers: [AnswerRequest] =
        incorrectAnswers.map {
            AnswerRequest(answerText: $0, isCorrect: false)
        } + [AnswerRequest(answerText: correctAnswer, isCorrect: true)]
        
        let newQuestion = QuestionRequest(
            categoryId: selectedCategory!.id,
            questionText: questionText,
            answers: answers
        )
        
        let endpoint = "questions"
        URLSession.shared.postData(endpoint: endpoint, body: newQuestion) {
            (result: Result<QuestionResult, QuizApiError>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.questionText = ""
                    self.incorrectAnswers = ["", ""]
                    self.correctAnswer = ""
                case .failure(let error):
                    self.hasError = true
                    self.error = error
                }
            }
        }
    }
    
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
                    if !self.categories.isEmpty {
                        self.selectedCategory = self.categories.first
                    }
                case .failure(let error):
                    self.hasError = true
                    self.error = error
                }
            }
        }
        
    }
    
    func clear() {
        hasError = false
        error = nil
        questionText = ""
        incorrectAnswers = ["", ""]
        correctAnswer = ""
    }
    
    func validateFields() -> Bool {
         guard !questionText.isEmpty else {
             return false
         }

         guard !incorrectAnswers.contains(where: { $0.isEmpty || $0.contains(" ") }) else {
             return false
         }

         guard !correctAnswer.isEmpty, !correctAnswer.contains(" ") else {
             return false
         }

         guard selectedCategory != nil else {
             return false
         }

         return true
     }
    
}
