//
//  SignInViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var alertMessage: String? = nil
    private let authenticationService: AuthenticationServiceProtocol
    private let imageUploader: ImageUploaderProtocol
    let onLoginSucceed: (() -> ())
    
    init(
        authenticationService: AuthenticationServiceProtocol,
        imageUploader: ImageUploaderProtocol,
        _ callback: @escaping () -> ()
    ) {
        self.authenticationService = authenticationService
        self.imageUploader = imageUploader
        self.onLoginSucceed = callback
    }
    
    var registrationViewModel: RegistrationViewModel {
        return RegistrationViewModel(
            authenticationService: authenticationService,
            imageUploader: imageUploader
        )
    }
    
    func onLoginAction(
        email: String,
        password: String,
        isLoading: @escaping (Bool) -> Void
    ) {
        alertMessage = nil
        
        if !isEmailValid(email: email) {
            alertMessage = "Incorrect email format, please try again."
        } else if password.isEmpty {
            alertMessage = "Please enter your password."
        } else {
            login(email: email, password: password)
        }
    }
    
    private func isEmailValid(email: String) -> Bool {
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")
        return usernameTest.evaluate(with: email)
    }
    
    private func login(email: String, password: String) {
        Task {
            await authenticationService.login(
                email: email,
                password: password,
                onSuccess: {
                    self.onLoginSucceed()
                },
                onFailure: { error in
                    self.alertMessage = "An error occur. Please try again."
                    print(error)
                }
            )
        }
    }
}
