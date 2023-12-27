//
//  ContentView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 12/11/2023.
//

import SwiftUI
import SimpleToast

struct CategoryListView: View {
    @ObservedObject var viewmodel: CategoriesViewModel
    @State var path = NavigationPath()
    @State private var isAddingCategory = false
    
    private struct Constants {
       static let noQuestionCount = 0
        struct Toast {
            static let alignment : Alignment = .bottom
            static let hideAfter: TimeInterval = 5
            static let color: Color = Color.green.opacity(0.8)
            static let textColor: Color = Color.white
            static let cornerRadius : CGFloat = 10
            static let padding : Edge.Set = .top
        }
    }
    
    
    private let toastOptions = SimpleToastOptions(
        alignment: Constants.Toast.alignment,
        hideAfter: Constants.Toast.hideAfter
    )

    
    var body: some View {
        NavigationStack (path: $path) {
            List {
                ForEach(viewmodel.categories, id: \.id) { category in
                    NavigationLink(value: category) {
                        HStack {
                            Image(systemName: category.icon)
                                .foregroundColor(.blue)
                                .imageScale(.large)
                            Text(category.name)
                                .font(.headline)
                        }
                    }.disabled(category.questionCount == Constants.noQuestionCount)
                }.onDelete(perform: { indexSet in
                    deleteCategory(at: indexSet)
                })
            }
            .alert(isPresented: $viewmodel.hasError, error: viewmodel.error, actions: {
                Button(action: fetch, label: {
                    Text("Retry")
                })
            })
            .navigationTitle("Quiz Categories")
            .navigationDestination(for: Category.self) { category in
                GameView(viewModel: QuizGame(category: category), navigationPath: $path)
            }
            .toolbar(content: {
                Button(action: {
                    isAddingCategory = true
                }) {
                    Image(systemName: "plus")
                }
            })
            .refreshable {
                fetch()
            }
            .sheet(isPresented: $isAddingCategory, content: {
                AddCategoryView(viewmodel: viewmodel, isPresented: $isAddingCategory)
            })
            .simpleToast(isPresented: $viewmodel.showToast, options: toastOptions) {
                Label(viewmodel.toastText, systemImage: "checkmark.circle.fill")
                    .padding()
                    .background(Constants.Toast.color)
                    .foregroundColor(Constants.Toast.textColor)
                    .cornerRadius(Constants.Toast.cornerRadius)
                    .padding(Constants.Toast.padding)
                }
        }.onAppear(perform: fetch )
    }
    
    private func deleteCategory(at indices : IndexSet){
        viewmodel.deleteCategory(at: indices)
    }
    
    private func fetch(){
        viewmodel.fetchCategories()
    }
    
}
