//
//  AddQuestionsView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 05/12/2023.
//

import SwiftUI

struct AddQuestionView: View {
    @StateObject var viewModel: AddQuestionViewModel = AddQuestionViewModel()
    
    
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
                        hideKeyboard()
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
        
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
