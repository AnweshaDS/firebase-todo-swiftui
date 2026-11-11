//
//  ContentView.swift
//  FirebaseTodo
//
//  Created by macos on 4/11/26.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        if let user = authVM.user {
            VStack(spacing: 16) {
                Text("Logged in as \(user.email ?? "")")
                Button("Logout") {
                    authVM.signOut()
                }
            }
        } else {
            AuthView()
        }
    }
}
