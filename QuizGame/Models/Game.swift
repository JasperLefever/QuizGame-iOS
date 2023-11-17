//
//  Game.swift
//  QuizGame
//
//  Created by Jasper Lefever on 15/11/2023.
//

import Foundation

struct Game {
    
    // MARK: - properties
    var questions: Array<Question>
    var score: Int = 0
    var currentCategory: Category?
    var categories: Array<Category>
    var currentQuestionIndex: Int = 0
    var isDone: Bool = false
    var isAnswered: Bool = false
    
    
    // MARK: functions
    
    mutating func selectCategory(_ cat : Category) {
        currentCategory = cat
    }
    
    mutating func check(answer answerIndex : Int) {
        isAnswered = true
        
        if isAnswerCorrect(at: answerIndex) {
            score += 1
        }
    }
    
    mutating func isAnswerCorrect(at index : Int) -> Bool {
        let correctAnswerIndex = questions[currentQuestionIndex].correctAnswerIndex
        return index == correctAnswerIndex
    }
    
    mutating func nextQuestion() {
        if currentQuestionIndex <= questions.count - 1 {
            isAnswered = false
            currentQuestionIndex += 1
        } else {
            // throw
        }
    }
}
