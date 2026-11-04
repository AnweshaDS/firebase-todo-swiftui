//
//  FirebaseTodoApp.swift
//  FirebaseTodo
//
//  Created by macos on 4/11/26.
//

import SwiftUI
import FirebaseCore

@main
struct FirebaseTodoApp: App {
    @StateObject private var authVM: AuthViewModel

    init() {
        FirebaseApp.configure()
        _authVM = StateObject(wrappedValue: AuthViewModel())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
        }
    }
}
