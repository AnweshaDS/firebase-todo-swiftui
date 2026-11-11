//
//  AuthView.swift
//  FirebaseTodo
//
//  Created by macos on 11/11/26.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            Text(isLogin ? "Login" : "Sign Up")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            SecureField("Password (min 6 characters)", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            if !authVM.errorMessage.isEmpty {
                Text(authVM.errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Button {
                if isLogin {
                    authVM.signIn(email: email, password: password)
                } else {
                    authVM.signUp(email: email, password: password)
                }
            } label: {
                Text(authVM.isLoading ? "Please wait..." : (isLogin ? "Login" : "Create account"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(authVM.isLoading || email.isEmpty || password.count < 6)

            Button(isLogin ? "No account? Sign up" : "Already have an account? Login") {
                authVM.errorMessage = ""
                isLogin.toggle()
            }
            .font(.footnote)
        }
        .padding(24)
    }
}
