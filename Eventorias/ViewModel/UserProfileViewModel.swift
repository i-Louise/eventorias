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
    private let db = Firestore.firestore()
    private let userService = UserService()
    @Published var errorMessage: String?
    @Published var user: UserResponseModel?
    
    func onActionFetchingUserProfile() {
        Task {
            do {
                user = try await userService.fetchUserProfile()
            } catch {
                errorMessage = "An error occurred: \(error)"
            }
        }
    }
}
