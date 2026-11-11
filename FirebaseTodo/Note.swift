//
//  Note.swift
//  FirebaseTodo
//
//  Created by macos on 7/11/26.
//


import Foundation

struct Note: Identifiable {
    let id: UUID
    var title: String
    var content: String
    var date: Date
    var colorIndex: Int
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        date: Date = Date(),
        colorIndex: Int = 0,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.colorIndex = colorIndex
        self.isFavorite = isFavorite
    }
}
