//
//  Game.swift
//  QuizGame
//
//  Created by Jasper Lefever on 15/11/2023.
//

import Foundation

struct Game {
    
    // MARK: - properties
    var questions: [Question] =  []
    var score: Int = 0
    var currentQuestionIndex: Int = 0
    var isDone: Bool = false
    var isAnswered: Bool = false
    
    
    // MARK: functions
    
    mutating func check(_ answer: Answer) {
        isAnswered = true
        
        if answer.isCorrect {
            score += 1
        }
    }
    
    mutating func nextQuestion() {
        if currentQuestionIndex < (questions.count - 1) {
            currentQuestionIndex += 1
            isAnswered = false
        } else {
            isDone = true
        }
    }
    
    mutating func setQuestions(_ questions: [Question]) {
        self.questions = questions
    }
    
}
