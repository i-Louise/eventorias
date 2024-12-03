//
//  UserServiceProtocol.swift
//  Eventorias
//
//  Created by Louise Ta on 03/12/2024.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUserProfile() async throws -> UserResponseModel?
}
