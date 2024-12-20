//
//  SignInViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import Foundation

class SignInViewModel: ObservableObject {
    @Published var alertMessage: String? = nil
    @Published var showingAlert = false
    private let authenticationService: AuthenticationServiceProtocol
    private let imageUploader: ImageUploaderProtocol
    @Published var isLoading = false
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
        password: String
    ) {
        alertMessage = nil
        isLoading = true
        
        if !isEmailValid(email: email) {
            isLoading = false
            alertMessage = "Incorrect email format, please try again."
        } else if password.isEmpty {
            isLoading = false
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
                    DispatchQueue.main.async {
                        self.onLoginSucceed()
                        self.isLoading = false
                    }
                },
                onFailure: { error in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.alertMessage = "Please check your credentials and try again."
                        self.showingAlert = true
                    }
                    print(error)
                }
            )
        }
    }
}
