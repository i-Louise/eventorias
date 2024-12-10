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
        onLoading: @escaping (Bool) -> Void
    ) {
        alertMessage = nil
        onLoading(true)
        
        if firstName.isEmpty {
            alertMessage = "Please enter your first name."
            onLoading(false)
        } else if lastName.isEmpty {
            alertMessage = "Please enter your last name."
            onLoading(false)
        } else if !isEmailValid(email: email) {
            alertMessage = "Incorrect email format."
            onLoading(false)
        } else if !isPasswordValid(password: password) {
            alertMessage = "Password must be more than 6 characters, with at least one capital, numeric or special character."
            onLoading(false)
        } else if password != confirmPassword {
            alertMessage = "Passwords are not matching."
            onLoading(false)
        } else {
            signUp(
                credentials: AuthCredentials(
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName
                ),
                image: image,
                onLoading: onLoading
            )
        }
    }
    
    private func signUp(credentials: AuthCredentials, image: Data, onLoading: @escaping (Bool) -> Void) {
        imageUploader.uploadImage(path: "users/profilePictures/\(UUID().uuidString).jpg", image: image) { imageUrl, error in
            if let error = error {
                        print("Image upload failed: \(error.localizedDescription)")
                        self.alertMessage = "Image upload failed"
                        return
                    }
            let newUser = UserRequestModel(authCredentials: credentials, profilePictureUrl: imageUrl ?? "imageUrl")
            Task {
                await self.authenticationService.registration(
                    user: newUser,
                    onSuccess: {
                        onLoading(false)
                    },
                    onFailure: { error in
                        print("Error registering user: \(error)")
                        self.alertMessage = "An error occured, while registering."
                        onLoading(false)
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
}
