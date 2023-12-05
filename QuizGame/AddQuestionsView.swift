//
//  AddQuestionsView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 05/12/2023.
//

import SwiftUI

struct AddQuestionView: View {
    @StateObject var viewModel: AddQuestionViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Select category", selection: $viewModel.selectedCategory) {
                    if viewModel.categories.isEmpty {
                        Text("No categories available")
                    } else {
                        ForEach(viewModel.categories) { category in
                            Text("\(category.name)").tag(category)
                        }
                    }
                    
                }.pickerStyle(.navigationLink)
                
                
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
                    .disabled(viewModel.allowSubmit)
                }
            }
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error, actions: {
            Button(action: viewModel.clear, label: {
                Text("Retry")
            })
        })
        .navigationTitle("Add new Question")
        .onTapGesture {
            hideKeyboard()
        }
        .refreshable {
            viewModel.fetchCategories()
        }
        
    }
}

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
