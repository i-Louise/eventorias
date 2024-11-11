//
//  RegistrationViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 11/11/2024.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var alertMessage: String? = nil
    @Published var isLoading = false
    private var authenticationService: AuthenticationServiceProtocol

    init(
         authenticationService: AuthenticationServiceProtocol = AuthenticationService()
    ) {
        self.authenticationService = authenticationService
    }
    
    func onSignUpAction(email: String, password: String, confirmPassword: String, onLoading: @escaping (Bool) -> Void) {
        alertMessage = nil
        onLoading(true)
        if !isEmailValid(email: email) {
            alertMessage = "Incorrect email format"
            onLoading(false)
        } else if password != confirmPassword {
            alertMessage = "Passwords are not matching"
            onLoading(false)
        } else {
            signUp(email: email, password: password) {
                onLoading(false)
            }
        }
    }
    
    private func isEmailValid(email: String) -> Bool {
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")
        return usernameTest.evaluate(with: email)
    }
    
    private func isPasswordValid(password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&? ]).*$")
        return passwordTest.evaluate(with: password)
    }
    
    func signUp(email: String, password: String, onCompletion: @escaping () -> Void) {
        authenticationService.registration(email: email, password: password) { success, error in
            if success {
                print("Successfully registered")
            } else if let error = error {
                print("Error message: \(error.localizedDescription)")
            }
            onCompletion()
        }
    }
}
