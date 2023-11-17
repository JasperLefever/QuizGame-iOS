//
//  CategoryStore.swift
//  QuizGame
//  ViewModel CategoryView
//  Created by Jasper Lefever on 15/11/2023.
//

import SwiftUI

class QuizGame: ObservableObject {

  // MARK: - Sample Data

  private static let qu: [Question] = [/*
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
  */]

  @Published private var model: Game = Game(questions: qu)

  var currentCategory: Category? {
    return model.currentCategory ?? nil
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

  // MARK: - Fetching data

  func fetchQuestions(for category: Category) {
    // logica voor ophalen van vragen juiste categorie
  }

  // MARK: Game Functions

  func check(_ answer: Answer) {
    model.check(answer)
  }

  func nextQuestion() {
    model.nextQuestion()
  }


}
