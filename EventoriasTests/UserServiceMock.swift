//
//  UserServiceMock.swift
//  EventoriasTests
//
//  Created by Louise Ta on 05/12/2024.
//

import Foundation
@testable import Eventorias

class UserServiceMock: UserServiceProtocol {
    var shouldSucceed = true
    var user: UserResponseModel?
    
    func fetchUserProfile() async throws -> UserResponseModel? {
        if shouldSucceed {
            return user
        } else {
            throw EventServiceError.unknownError
        }
    }
}
