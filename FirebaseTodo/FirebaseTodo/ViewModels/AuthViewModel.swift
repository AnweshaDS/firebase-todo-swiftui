//
//  AuthViewModel.swift
//  FirebaseTodo
//
//  Created by macos on 11/11/26.
//

import Foundation
import FirebaseAuth

final class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage = ""
    @Published var isLoading = false

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        user = Auth.auth().currentUser
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.user = user
            }
        }
    }

    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func signUp(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
