//
//  AuthenticationService.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import Foundation
import FirebaseAuth

class AuthenticationService: AuthenticationServiceProtocol, ObservableObject {
    static let shared = AuthenticationService()
    @Published var isAuthenticated = false
    
    func login(email: String, password: String, completion: @escaping (Bool, (any Error)?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let user = authResult?.user {
                self?.isAuthenticated = true
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
