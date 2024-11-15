//
//  SignInViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alertMessage: String? = nil
    private let authenticationService: AuthenticationServiceProtocol
    
    
    init(
        authenticationService: AuthenticationServiceProtocol = AuthenticationService()
    ) {
        self.authenticationService = authenticationService
    }
    
    func onLoginAction(email: String, password: String, onLoading: @escaping (Bool) -> Void) {
        alertMessage = nil
        onLoading(true)
        if !isEmailValid(email: email) {
            alertMessage = "Incorrect email format, please try again."
            onLoading(false)
        } else if password.isEmpty {
            alertMessage = "Please enter your password."
            onLoading(false)
        } else {
            login(email: email, password: password) {
                onLoading(false)
            }
        }
    }
    
    private func isEmailValid(email: String) -> Bool {
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")
        return usernameTest.evaluate(with: email)
    }
    
    func login(email: String, password: String, onCompletion: @escaping () -> Void) {
        authenticationService.login(email: email, password: password) { success, error in
            if success {
                print("Login succeed")
            } else if let error = error {
                print("Error message: \(error.localizedDescription)")
            }
            onCompletion()
        }
    }
}
