//
//  AddCategoryView.swift
//  QuizGame
//
//  Created by Jasper Lefever on 04/12/2023.
//

import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var viewmodel: CategoriesViewModel
    @Binding var isPresented: Bool
    @State private var categoryName = ""
    @State private var selectedIcon = "star"
    @State private var isAddButtonDisabled = true

    let systemIcons = ["star", "heart", "circle", "square", "triangle"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Information")) {
                    TextField("Category Name", text: $categoryName)
                        .onChange(of: categoryName) { _, newValue in
                            isAddButtonDisabled = newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        }
                }

                Section(header: Text("Select Icon")) {
                    Picker("Icon", selection: $selectedIcon) {
                        ForEach(systemIcons, id: \.self) { iconName in
                            Image(systemName: iconName)
                                .tag(iconName)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section {
                    Button("Add Category") {
                        viewmodel.addCategory(name: categoryName, icon: selectedIcon)
                        
                        isPresented = false
                    }.disabled(isAddButtonDisabled)
                }
            }
            .navigationBarTitle("Add Category", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                }
            )
        }
    }
}
