import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: QuizGame
    @State var showAlert: Bool = false
    @EnvironmentObject var history: GameHistoryViewModel
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                landscapeLayout
            } else {
                portraitLayout
            }
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
            Button("Retry", action: viewModel.fetchQuestions)
        }
        .alert("Score", isPresented: $showAlert) {
            Button("End", action: {
                endGame()
            })
        } message: {
            Text("Your score was: \(viewModel.score)")
        }
    }
    
    private var portraitLayout: some View {
        VStack {
            if viewModel.isLoading {
                loadingView
            } else {
                gameInfoRow
                questionView
                Spacer()
                bottomButtons
            }
        }
        .padding()
    }
    
    private var landscapeLayout: some View {
        HStack {
            if viewModel.isLoading {
                loadingView
            } else {
                GeometryReader { geometry in
                    HStack {
                        VStack {
                            ScoreView(score: viewModel.score)
                            ProgressView(currentQuestion: viewModel.currentQuestionIndex + 1, totalQuestions: viewModel.totalQuestions)
                            Spacer()
                            bottomButtons
                        }.frame(width: geometry.size.width * 0.3)
                        VStack {
                            questionView.padding(0)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private var loadingView: some View {
        SwiftUI.ProgressView {
            Text("Loading")
        }
    }
    
    private var questionView: some View {
        VStack(alignment: .center) {
            Text(viewModel.currentQuestion.question)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
                .fixedSize(horizontal: false, vertical: true)
            
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
    
    private var gameInfoRow: some View {
        HStack {
            ProgressView(currentQuestion: viewModel.currentQuestionIndex,
                         totalQuestions: viewModel.totalQuestions)
            .padding()
            .accentColor(.blue)
            Spacer()
            ScoreView(score: viewModel.score)
        }
    }
    
    private var bottomButtons: some View {
        Group {
            if !viewModel.isDone {
                Button("Next", action: viewModel.nextQuestion)
                    .padding()
                    .disabled(!viewModel.isAnswered)
            } else {
                Button("Show results", action: { showAlert = true })
                    .disabled(!viewModel.isAnswered)
            }
        }
    }
    
    private func endGame() {
        history.addGameToHistory(category: viewModel.category.name, score: viewModel.score, date: Date())
        navigationPath.removeLast(navigationPath.count)
    }
    
    private func color(for answer: Answer) -> Color {
        if viewModel.isAnswered {
            return answer.isCorrect ? .green : .red
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
