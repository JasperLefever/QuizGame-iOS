//
//  GameView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 15/11/2023.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: QuizGame
    @State var showAlert: Bool = false
    @State var navigateBack = false
    @EnvironmentObject var history: GameHistoryViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                SwiftUI.ProgressView {
                    Text("Loading")
                }
            } else {
                VStack {
                    gameInfoRow
                    
                    questionView
                }
                
                Spacer()
                
                if !viewModel.isDone {
                    next
                } else {
                    showResults
                }
            }
        }
        .padding()
        .alert(isPresented: $viewModel.hasError, error: viewModel.error,
               actions: {
            Button(action: viewModel.fetchQuestions,
                   label: {Text("Retry")})
        }
        )
        .alert(
            "Score", isPresented: $showAlert,
            actions: {
                Button(
                    "End",
                    action: {
                        history.addGameToHistory(category: viewModel.currentCategory!.name, score: viewModel.score, date: Date())
                        viewModel.endGame()
                        
                    })
            },
            message: {
                Text("Your score was: \(viewModel.score)")
            }
        )
    }
    
    private var questionView: some View {
        VStack(alignment: .center) {
            Text(viewModel.currentQuestion.question)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            
            ForEach(viewModel.currentQuestion.answers, id: \.self) { answer in
                Button(action: {
                    viewModel.check(answer)
                }) {
                    Text(answer.text)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(color(for: answer))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .disabled(viewModel.isAnswered)
            }
        }
        .padding()
    }
    
    private var next: some View {
        Button("Next") {
            viewModel.nextQuestion()
        }
        .padding()
        .disabled(!viewModel.isAnswered)  // zet knop af als nog niet beantwoord is
    }
    
    private var gameInfoRow: some View {
        HStack {
            ProgressView(
                currentQuestion: viewModel.currentQuestionIndex,
                totalQuestions: viewModel.totalQuestions
            )
            .padding()
            .accentColor(.blue)
            Spacer()
            ScoreView(score: viewModel.score)
        }
    }
    
    private var showResults : some View {
        Button("Show results",action: {
            showAlert = true
        })
        .disabled(!viewModel.isAnswered)  // zet knop af als nog niet beantwoord is
    }
    
    private func color(for answer: Answer) -> Color {
        if viewModel.isAnswered {
            if answer.isCorrect {
                return .green
            } else {
                return .red
            }
        } else {
            return .blue
        }
    }
}

struct ScoreView: View {
    var score: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.blue)
            .frame(width: 80, height: 40)
            .overlay {
                Text("Score: \(score)")
                    .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16))
    }
}

struct ProgressView: View {
    var currentQuestion: Int
    var totalQuestions: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.blue)
            .frame(width: 150, height: 40)
            .overlay {
                Text("Question \(currentQuestion + 1) of \(totalQuestions)")
                    .foregroundColor(.white)
                    .font(.body)
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16))
    }
    
}
