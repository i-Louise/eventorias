//
//  RegistrationViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 11/11/2024.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var alertMessage: String? = nil
    @Published var showingAlert = false
    @Published var firstNameErrorMessage: String? = nil
    @Published var lastNameErrorMessage: String? = nil
    @Published var emailErrorMessage: String? = nil
    @Published var passwordErrorMessage: String? = nil
    @Published var confirmPasswordErrorMessage: String? = nil
    @Published var isLoading = false
    private var authenticationService: AuthenticationServiceProtocol
    private let imageUploader: ImageUploaderProtocol
    
    init(
        authenticationService: AuthenticationServiceProtocol,
        imageUploader: ImageUploaderProtocol
    ) {
        self.authenticationService = authenticationService
        self.imageUploader = imageUploader
    }
    
    func onSignUpAction(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        confirmPassword: String,
        image: Data,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        clearMessages()

        if firstName.isEmpty {
            firstNameErrorMessage = "Please enter your first name."
        } else if lastName.isEmpty {
            lastNameErrorMessage = "Please enter your last name."
        } else if !isEmailValid(email: email) {
            emailErrorMessage = "Incorrect email format."
        } else if !isPasswordValid(password: password) {
            passwordErrorMessage = "Password must be more than 6 characters, with at least one capital, numeric or special character."
        } else if password != confirmPassword {
            confirmPasswordErrorMessage = "Passwords are not matching."
        } else {
            signUp(
                credentials: AuthCredentials(
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName
                ),
                image: image,
                onSuccess: onSuccess,
                onFailure: onFailure
            )
        }
    }
    
    private func signUp(
        credentials: AuthCredentials,
        image: Data,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        imageUploader.uploadImage(path: "users/profilePictures/\(UUID().uuidString).jpg", image: image) { imageUrl, error in
            if let error = error {
                        print("Image upload failed: \(error.localizedDescription)")
                        self.alertMessage = "Image upload failed"
                        self.isLoading = false
                        return
                    }
            let newUser = UserRequestModel(authCredentials: credentials, profilePictureUrl: imageUrl ?? "imageUrl")
            Task {
                await self.authenticationService.registration(
                    user: newUser,
                    onSuccess: {
                        self.isLoading = false
                        onSuccess()
                    },
                    onFailure: { error in
                        self.alertMessage = "An error occured, while registering."
                        self.showingAlert = true
                        self.isLoading = false
                        onFailure(self.alertMessage ?? "")
                    }
                )
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
    
    private func clearMessages() {
        firstNameErrorMessage = nil
        lastNameErrorMessage = nil
        emailErrorMessage = nil
        passwordErrorMessage = nil
        confirmPasswordErrorMessage = nil
    }
}
