//
//  AuthenticationServiceProtocol.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import Foundation

protocol AuthenticationServiceProtocol {
    func login(
        email: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) async
    
    func registration(
        user: UserRequestModel,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) async
}
