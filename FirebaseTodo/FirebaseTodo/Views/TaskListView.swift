//
//  TaskListView.swift
//  FirebaseTodo
//
//  Created by macos on 11/11/26.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var taskVM = TaskViewModel()

    @State private var showForm = false
    @State private var editingTask: TodoItem?

    var body: some View {
        NavigationView {
            Group {
                if taskVM.tasks.isEmpty {
                    Text("No tasks yet. Tap + to add one.")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(taskVM.tasks) { task in
                            HStack(alignment: .top, spacing: 12) {
                                Button {
                                    taskVM.toggleComplete(task)
                                } label: {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                }
                                .buttonStyle(.plain)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title)
                                        .font(.headline)
                                        .strikethrough(task.isCompleted)
                                    if !task.details.isEmpty {
                                        Text(task.details)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                editingTask = task
                                showForm = true
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    taskVM.deleteTask(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") {
                        taskVM.stop()
                        authVM.signOut()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editingTask = nil
                        showForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !taskVM.errorMessage.isEmpty {
                    Text(taskVM.errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .sheet(isPresented: $showForm) {
                TaskFormView(taskVM: taskVM, task: editingTask)
                    .environmentObject(authVM)
            }
            .onAppear {
                if let uid = authVM.user?.uid {
                    taskVM.start(uid: uid)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
