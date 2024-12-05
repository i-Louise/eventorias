//
//  File.swift
//  EventoriasTests
//
//  Created by Louise Ta on 03/12/2024.
//

import Foundation
@testable import Eventorias

class MockAuthenticationService: AuthenticationServiceProtocol {
    var shouldSucceedLogin = true
    var shouldSucceedRegistration = true
    var loginCalled = false
    var registrationCalled = false

    func login(
        email: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) async {
        loginCalled = true
        if shouldSucceedLogin {
            onSuccess()
        } else {
            onFailure("Login failed")
        }
    }

    func registration(
        user: UserRequestModel,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) async {
        registrationCalled = true
        if shouldSucceedRegistration {
            onSuccess()
        } else {
            onFailure("Registration failed")
        }
    }
}
