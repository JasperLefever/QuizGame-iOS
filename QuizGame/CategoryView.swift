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
    
    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 5
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
                    }.disabled(category.questionCount == 0)
                }.onDelete(perform: { indexSet in
                    deleteCategory(at: indexSet)
                })
            }
            .alert(isPresented: $viewmodel.hasError, error: viewmodel.error, actions: {
                Button(action: viewmodel.fetchCategories, label: {
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
                viewmodel.fetchCategories()
            }
            .sheet(isPresented: $isAddingCategory, content: {
                AddCategoryView(viewmodel: viewmodel, isPresented: $isAddingCategory)
            })
            .simpleToast(isPresented: $viewmodel.showToast, options: toastOptions) {
                Label(viewmodel.toastText, systemImage: "checkmark.circle.fill")
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .padding(.top)
                }
        }.onAppear(perform: viewmodel.fetchCategories )
    }
    
    private func deleteCategory(at indices : IndexSet){
        viewmodel.deleteCategory(at: indices)
    }
    
    
}
