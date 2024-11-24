//
//  AuthenticationService.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationService: AuthenticationServiceProtocol {
    func login(
        email: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) async {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            onSuccess()
        } catch {
            onFailure("Could not login user: \(error.localizedDescription)")
        }
    }
    
    func registration(
        credentials: AuthCredentials,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) async {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: credentials.email, password: credentials.password)
            try await Firestore.firestore().collection("users").document(authResult.user.uid).setData([
                "email": credentials.email,
                "firstName": credentials.firstName,
                "lastName": credentials.lastName
            ])
            onSuccess()
        } catch {
            onFailure("Could not sign up user: \(error.localizedDescription)")
        }
    }
}
