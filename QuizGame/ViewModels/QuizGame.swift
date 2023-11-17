//
//  CategoryStore.swift
//  QuizGame
//  ViewModel CategoryView
//  Created by Jasper Lefever on 15/11/2023.
//

import SwiftUI

class QuizGame: ObservableObject {
    
    // MARK: - Sample Data
    private static let cat: [Category] = [
        Category(id: 1, name: "Technology", icon: "gear"),
           Category(id: 2, name: "Science", icon: "atom"),
           Category(id: 3, name: "Travel", icon: "airplane"),
           Category(id: 4, name: "Food", icon: "fork.knife"),
           Category(id: 5, name: "Music", icon: "music.note"),
    ]
    private static let qu: [Question] = [
        Question(
            question: "What is the capital of France?",
            answers: ["Berlin", "Paris", "London", "Madrid"],
            correctAnswerIndex: 1
        ),
        Question(
            question: "Which planet is known as the Red Planet?",
            answers: ["Venus", "Mars", "Jupiter", "Saturn"],
            correctAnswerIndex: 1
        ),
        Question(
            question: "Who wrote 'Romeo and Juliet'?",
            answers: ["Charles Dickens", "William Shakespeare", "Jane Austen", "Emily Brontë"],
            correctAnswerIndex: 1
        ),
    ]
    
    @Published private var model: Game = Game(questions: qu, categories: cat)
    
    var currentCategory: Category? {
        return model.currentCategory ?? nil
    }
    
    var questions: Array<Question> {
        return model.questions
    }
    
    var score: Int {
        return model.score
    }
    
    var categories: Array<Category> {
        return model.categories
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
    
    // MARK: - Fetching data
    
    func fetchQuestions(for category: Category) {
        // logica voor ophalen van vragen juiste categorie
    }
    
    // MARK: Category functions
    
    func selectCategory(_ category : Category) {
        model.selectCategory(category)
    }
    
    
    // MARK: Game Functions
    
    func check(answer answerIndex: Int) {
        model.check(answer: answerIndex)
    }
    
    func nextQuestion () {
        model.nextQuestion()
    }
    
    
    func isAnswerCorrect(at index :Int ) -> Bool {
        return model.isAnswerCorrect(at: index)
    }

    
    
}
