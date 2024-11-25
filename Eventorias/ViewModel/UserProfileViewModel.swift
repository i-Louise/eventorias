//
//  UserProfileViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 22/11/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserProfileViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var user: UserResponseModel?
    
    func fetchUserProfile() {
        Task {
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            do {
                let documentSnapShot = try await db.collection("users").document(currentUser).getDocument()
                
                if let user = try documentSnapShot.data(as: UserResponseModel?.self) {
                    DispatchQueue.main.async {
                        self.user = user
                    }
                }
            } catch let error as NSError {
                print("Error fetching user: \(error.localizedDescription)")
            }
        }
    }
}
