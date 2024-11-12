//
//  AuthenticationService.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationService: AuthenticationServiceProtocol, ObservableObject {
    @Published var isAuthenticated = false
    
    func login(email: String, password: String, completion: @escaping (Bool, (any Error)?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if (authResult?.user) != nil {
                self?.isAuthenticated = true
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func registration(credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        ImageUploader.uploadImage(image: credentials.profileImage) { imageURL in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error {
                    print("Err: Failed to register user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else {return}
                let data: [String: Any] = ["email": credentials.email,
                                           "firstName": credentials.firstName,
                                           "profileImageURL": imageURL,
                                           "uid": uid]
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            }
        }
    }
}
