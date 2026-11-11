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
        if authVM.user != nil {
            TaskListView()
        } else {
            AuthView()
        }
    }
}
