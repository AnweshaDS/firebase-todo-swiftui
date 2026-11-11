//
//  TaskViewModel.swift
//  FirebaseTodo
//
//  Created by macos on 11/11/26.
//

import Foundation
import FirebaseFirestore

final class TaskViewModel: ObservableObject {
    @Published var tasks: [TodoItem] = []
    @Published var errorMessage = ""

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    // READ: real-time listener, only this user's tasks
    func start(uid: String) {
        listener?.remove()
        listener = db.collection("tasks")
            .whereField("uid", isEqualTo: uid)
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    let items = snapshot?.documents.compactMap { TodoItem(document: $0) } ?? []
                    self.tasks = items.sorted {
                        ($0.createdAt ?? Date.distantFuture) > ($1.createdAt ?? Date.distantFuture)
                    }
                }
            }
    }

    func stop() {
        listener?.remove()
        listener = nil
        tasks = []
    }

    // CREATE
    func addTask(title: String, details: String, uid: String) {
        db.collection("tasks").addDocument(data: [
            "title": title,
            "description": details,
            "completed": false,
            "uid": uid,
            "createdAt": FieldValue.serverTimestamp()
        ]) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // UPDATE
    func updateTask(_ task: TodoItem, title: String, details: String) {
        db.collection("tasks").document(task.id).updateData([
            "title": title,
            "description": details
        ]) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func toggleComplete(_ task: TodoItem) {
        db.collection("tasks").document(task.id).updateData([
            "completed": !task.isCompleted
        ]) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // DELETE
    func deleteTask(_ task: TodoItem) {
        db.collection("tasks").document(task.id).delete { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
