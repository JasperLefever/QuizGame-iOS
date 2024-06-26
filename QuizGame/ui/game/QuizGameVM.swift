//
//  CategoryStore.swift
//  QuizGame
//  ViewModel CategoryView
//  Created by Jasper Lefever on 15/11/2023.
//

import SwiftUI

class QuizGame: ObservableObject {
    var category: Category
    @Published var hasError = false
    @Published var error: QuizApiError?
    @Published var isLoading = true
    
    @Published private var model: Game = Game()
    
    init(category: Category) {
        self.category = category
        fetchQuestions()
    }
    
    var questions: [Question] {
        return model.questions
    }
    
    var score: Int {
        return model.score
    }
    
    var currentQuestionIndex: Int {
        return model.currentQuestionIndex
    }
    
    var totalQuestions: Int {
        return model.questions.count
    }
    
    var currentQuestion: Question {
        return model.questions[currentQuestionIndex]
    }
    
    var isAnswered: Bool {
        return model.isAnswered
    }
    
    var isDone: Bool {
        return model.currentQuestionIndex == (model.questions.count - 1)
    }
    
    // MARK: Game Functions
    
    func check(_ answer: Answer) {
        model.check(answer)
    }
    
    func nextQuestion() {
        model.nextQuestion()
    }
    
    func fetchQuestions() {
        hasError = false
        isLoading = true
        let page = 1
        let perPage = 10
        let endpoint = "questions/category/\(category.id)?page=\(page)&perPage=\(perPage)"
        URLSession.shared.fetchData(endpoint: endpoint) {
            (result: Result<QuestionsResult, QuizApiError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    
                    let questions = data.items!.map { questionResult -> Question in
                        Question(
                            id: questionResult.id,
                            categoryId: questionResult.category.id,
                            question: questionResult.questionText,
                            answers: questionResult.answers.map { answerResult -> Answer in
                                Answer(
                                    id: answerResult.id,
                                    text: answerResult.answerText,
                                    isCorrect: answerResult.isCorrect)
                            })
                    }
                    self.model.setQuestions(questions)
                    
                    self.isLoading = false
                case .failure(let error):
                    print(error)
                    self.hasError = true
                    self.error = error
                    self.isLoading = false
                }
            }
        }
        
    }
    
    
}
