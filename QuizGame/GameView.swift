//
//  GameView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 15/11/2023.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: QuizGame

    var body: some View {
        VStack {
            VStack {
                HStack {
                    ProgressView(currentQuestion: viewModel.currentQuestionIndex, totalQuestions: viewModel.totalQuestions)
                        .padding()
                        .accentColor(.blue)
                    Spacer()
                    ScoreView(score: viewModel.score)
                }
                
                QuestionView(viewModel: viewModel)
            }
            
            Spacer()
            if (!viewModel.isDone) {
                Button("Next") {
                    viewModel.nextQuestion()
                }
                .padding()
                .disabled(!viewModel.isAnswered) // zet knop af als nog niet beantwoord is
            } else {
                Button("Show Results") {
                    // show results
                }
                .disabled(!viewModel.isAnswered) // zet knop af als nog niet beantwoord is
            }

            
        }
        .padding()
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


struct QuestionView: View {
    @ObservedObject var viewModel: QuizGame

    var body: some View {
        VStack(alignment: .center) {
            Text(viewModel.currentQuestion.question)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)

            ForEach(0..<viewModel.currentQuestion.answers.count, id: \.self) { index in
                Button(action: {
                    viewModel.check(answer: index)
                }) {
                    Text(viewModel.currentQuestion.answers[index])
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .disabled(viewModel.isAnswered)
            }
        }
        .padding()
    }
}


#Preview {
    GameView(viewModel: QuizGame())
}
