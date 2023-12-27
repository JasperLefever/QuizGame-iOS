//
//  AddQuestionsView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 05/12/2023.
//

import SwiftUI
import SimpleToast

struct AddQuestionView: View {
    @StateObject var viewModel: AddQuestionViewModel = AddQuestionViewModel()
    
    private let toastOptions = SimpleToastOptions(
        alignment: Constants.Toast.alignment,
        hideAfter: Constants.Toast.hideAfter
    )

    
    private struct Constants {
        struct Toast {
            static let alignment : Alignment = .bottom
            static let hideAfter: TimeInterval = 5
            static let color: Color = Color.green.opacity(0.8)
            static let textColor: Color = Color.white
            static let cornerRadius : CGFloat = 10
            static let padding : Edge.Set = .top
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Select category", selection: $viewModel.selectedCategory) {
                    if viewModel.categories.isEmpty {
                        Text("None").tag(Optional<Category>.none)
                    } else {
                        ForEach(viewModel.categories) { category in
                            Text("\(category.name)").tag(Optional<Category>.some(category))
                        }
                    }
                    
                }.pickerStyle(.navigationLink)
                    .disabled(viewModel.categories.isEmpty)
                
                
                Section(header: Text("Question")) {
                    TextField("Enter your question", text: $viewModel.questionText)
                }
                
                Section(header: Text("Correct answer")) {
                    TextField("Enter the correct answer", text: $viewModel.correctAnswer)
                }
                
                Section(header: Text("Incorrect answers")) {
                    ForEach($viewModel.incorrectAnswers.indices, id: \.self) { index in
                        TextField("Enter answer \(index + 1)", text: $viewModel.incorrectAnswers[index])
                    }
                }
                
                
                Section {
                    Button("Add Question") {
                        viewModel.saveQuestion()
                    }
                    .disabled(!viewModel.validateFields())
                }
            }
            .navigationTitle("Add new Question")
            .toolbar {
                
                ToolbarItem (placement: .topBarLeading) {
                    Button(action: {
                        hideKeyboard()
                        viewModel.clear()
                    }) {
                        Text("Clear")
                    }
                }
                
                ToolbarItem (placement: .topBarTrailing) {
                    Button(action: {
                        hideKeyboard()
                    }) {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
                
                ToolbarItem (placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.saveQuestion()
                    }) {
                        Text("Save")
                    }.disabled(!viewModel.validateFields())
                }
                
            }
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error, actions: {
            Button(action: viewModel.clear, label: {
                Text("Retry")
            })
        })
        .refreshable {
            viewModel.fetchCategories()
        }
        .simpleToast(isPresented: $viewModel.showToast, options: toastOptions) {
            Label(viewModel.toastText, systemImage: "checkmark.circle.fill")
                .padding()
                .background(Constants.Toast.color)
                .foregroundColor(Constants.Toast.textColor)
                .cornerRadius(Constants.Toast.cornerRadius)
                .padding(Constants.Toast.padding)
            }
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
