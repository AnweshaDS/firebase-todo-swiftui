//
//  TaskFormView.swift
//  FirebaseTodo
//
//  Created by macos on 11/11/26.
//

import SwiftUI

struct TaskFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @ObservedObject var taskVM: TaskViewModel

    let task: TodoItem?
    @State private var title: String
    @State private var details: String

    init(taskVM: TaskViewModel, task: TodoItem?) {
        self.taskVM = taskVM
        self.task = task
        _title = State(initialValue: task?.title ?? "")
        _details = State(initialValue: task?.details ?? "")
    }

    private var cleanTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Task title", text: $title)
                }
                Section(header: Text("Description")) {
                    TextEditor(text: $details)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(task == nil ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let cleanDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)
                        if let task = task {
                            taskVM.updateTask(task, title: cleanTitle, details: cleanDetails)
                        } else if let uid = authVM.user?.uid {
                            taskVM.addTask(title: cleanTitle, details: cleanDetails, uid: uid)
                        }
                        dismiss()
                    }
                    .disabled(cleanTitle.isEmpty)
                }
            }
        }
    }
}
