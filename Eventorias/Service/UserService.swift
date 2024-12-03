//
//  UserService.swift
//  Eventorias
//
//  Created by Louise Ta on 03/12/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService: UserServiceProtocol {
    private let db = Firestore.firestore()
    
    func fetchUserProfile() async throws -> UserResponseModel? {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user")
            return nil
        }
        do {
            let documentSnapShot = try await db.collection("users").document(currentUserID).getDocument()
            return try documentSnapShot.data(as: UserResponseModel?.self)
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            throw error
        }
    }
}
