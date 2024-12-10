//
//  UserProfileViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 22/11/2024.
//

import Foundation

class UserProfileViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    @Published var errorMessage: String?
    @Published var user: UserResponseModel?
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func onActionFetchingUserProfile() {
        Task {
            do {
                user = try await userService.fetchUserProfile()
            } catch {
                errorMessage = "Could not load your profile."
            }
        }
    }
}
