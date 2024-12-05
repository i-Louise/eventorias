//
//  UserResponseModel.swift
//  Eventorias
//
//  Created by Louise Ta on 24/11/2024.
//

import Foundation

struct UserResponseModel: Decodable, Equatable {
    let email: String
    let firstName: String
    let lastName: String
    let profilePicture: String
}
