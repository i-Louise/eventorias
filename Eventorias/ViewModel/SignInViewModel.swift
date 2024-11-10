//
//  SignInViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class SignInViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alertMessage: String? = nil
    private var authenticationService: AuthenticationServiceProtocol
    

    init(
         authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
    ) {
        self.authenticationService = authenticationService
    }
    
    func onLoginAction(mail: String, password: String, onLoading: @escaping (Bool) -> Void) {
        alertMessage = nil
        onLoading(true)
        if !isEmailValid(mail: mail) {
            alertMessage = "Incorrect mail format, please try again."
            onLoading(false)
        } else if password.isEmpty {
            alertMessage = "Please enter your password."
            onLoading(false)
        } else {
            login(mail: mail, password: password) {
                onLoading(false)
            }
        }
    }
    
    private func isEmailValid(mail: String) -> Bool {
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")
        return usernameTest.evaluate(with: mail)
    }
    
    func login(mail: String, password: String, onCompletion: @escaping () -> Void) {
        authenticationService.login(email: mail, password: password) { success, error in
            if success {
                print("Login succeed")
            } else if let error = error {
                print("Error message: \(error.localizedDescription)")
            }
            onCompletion()
        }
    }
}
