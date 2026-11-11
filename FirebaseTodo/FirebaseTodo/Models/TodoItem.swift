//
//  TodoItem.swift
//  FirebaseTodo
//
//  Created by macos on 11/11/26.
//

import Foundation
import FirebaseFirestore

struct TodoItem: Identifiable {
    let id: String
    var title: String
    var details: String
    var isCompleted: Bool
    let uid: String
    var createdAt: Date?

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let title = data["title"] as? String,
              let uid = data["uid"] as? String else {
            return nil
        }
        self.id = document.documentID
        self.title = title
        self.details = data["description"] as? String ?? ""
        self.isCompleted = data["completed"] as? Bool ?? false
        self.uid = uid
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
    }
}
